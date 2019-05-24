command jq --version > /dev/null 2>&1 || {  echo "Missing jq command!"; exit 1;  }

console_base_url=${console_base_url:-http://ec2-100-25-182-57.compute-1.amazonaws.com:8081}
# GET token and cookies
cookies=$(set -o pipefail; curl --connect-timeout 1 --max-time 3 -s -I -u cast:cast -XGET "$console_base_url"/api/user | sed -n -E 's/^Set-Cookie: (.*;) Path=.*$/\1/p' | paste -s -d ' ')
if (( $? != 0 ))
then
  printf "Fail to login with base url '%s'. Please check its availability.\n" "$console_base_url"
  exit 1
fi
[ -n "$DEBUG" ] &&  { printf "Cookies %s" "$cookies"; echo;  } 1>&2

#curl -s -u cast:cast -X GET --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2)" --header 'Content-Type: application/json' --header 'Accept: application/json' "$console_base_url"/api/ | python -mjson.tool

#curl -u cast:cast -X PUT --header 'Cookie: {{cookie.stdout}}' --header 'X-XSRF-TOKEN: {{cookie.stdout.split(' ')[0].split('=')[1][:-1]}}' --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"database":{"host":"{{aip_postgres_ip}}","port":5432,"userName":"operator","password":"CastAIP"},"schemaName":"general_measure"}' 'http://localhost:8081/api/settings/measurement-settings'

# create application

get_nodes() {
  curl -s -u cast:cast -X GET --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2)" --header 'Content-Type: application/json' --header 'Accept: application/json' "$console_base_url"/api/nodes | python -mjson.tool
}

get_applications() {
  curl -s -u cast:cast -X GET --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2)" --header 'Content-Type: application/json' --header 'Accept: application/json' "$console_base_url"/api/applications | python -mjson.tool
}

get_accessible_nodes() {
  get_nodes | jq 'map(select(.accessible))'
}

get_best_available_node() {
  get_accessible_nodes | jq 'min_by(.numberOfApplications)|.guid'
}

post_job_add_version_data() {
appName=${appName}; [ -z "$appName" ] && return 1;
appGuid=${appGuid}; [ -z "$appGuid" ] && return 1;
versionName=${versionName}; [ -z "$versionName" ] && return 1;
fileName=${fileName}; [ -z "$fileName" ] && return  1;
fileSize=${fileSize}; [ -z "$fileSize" ] && return 1;

  cat <<JSON
{"jobType":"add_version","jobParameters":{"appGuid":"$appGuid","appName":"$appName","versionName":"$versionName","releaseDate":"2019-05-07T16:47:53+02:00","fileName":"$fileName","fileSize":$fileSize,"startStep":"unzip_source","endStep":"consolidate_snapshot"}}
JSON

}

job_payload() {
jobType=${jobType}; [ -z "$jobType" ] && return 1;
jobParametersFunc=${jobParametersFunc}; [ -z "$jobParametersFunc" ] && return 1;

if declare -F "$jobParametersFunc" > /dev/null
then
  cat <<JSON
{"jobType":"$jobType","jobParameters":$($jobParametersFunc)}
JSON
fi

}

job_declare_application_payload() {
  declare_application_payload() {
    cat <<JSON
{"appName":"$name","nodeGuid":$(get_best_available_node),"domainName":null}
JSON
}

jobType="declare_application" \
  jobParametersFunc=declare_application_payload \
  job_payload
}

create_application() {
  local name=${name}; [ -z "$name" ] && echo "Application name missing" && exit 1;
  curl "$console_base_url"/api/jobs -X POST  -s -u cast:cast --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2 | tr -d ';')" --header 'Content-Type: application/json' --header 'Accept: application/json'  -d @<(name="$name" job_declare_application_payload) | jq '.jobGuid'  | tr -d '"' | {
  read -r jobGuid;
  curl -s -u cast:cast -X GET --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2)" --header 'Content-Type: application/json' --header 'Accept: application/json' "$console_base_url"/api/jobs/"$jobGuid" | python -mjson.tool
}

}



post_job2() {

curl "http://ec2-100-26-49-152.compute-1.amazonaws.com:8081/api/jobs" -H "Cookie: JSESSIONID=BDCAC510CF45E030350F40C1E571E88D; XSRF-TOKEN=63ed0d96-3f6c-4839-85b3-e490601b8806" -H "Origin: http://ec2-100-26-49-152.compute-1.amazonaws.com:8081" -H "X-XSRF-TOKEN: 63ed0d96-3f6c-4839-85b3-e490601b8806" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-US,en;q=0.9,de;q=0.8,fr;q=0.7" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.157 Safari/537.36" -H "Content-Type: application/json;charset=UTF-8" -H "Accept: application/json, text/plain, */*" -H "Referer: http://ec2-100-26-49-152.compute-1.amazonaws.com:8081/ui/index.html" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" --data-binary "^{^\^"jobType^\^":^\^"declare_application^\^",^\^"jobParameters^\^":^{^\^"appName^\^":^\^"test4^\^",^\^"nodeGuid^\^":^\^"de27da64-e6cc-56b5-9ed8-e91eb648083b^\^",^\^"domainName^\^":null^}^}" --compressed

}

func=$1; shift
if declare -F | cut -d ' ' -f3 | grep -q "^${func}$"
then
  $func "$@"
else
  printf "Usage : $0 %s" "$(declare -F | cut -d ' ' -f3 | paste -s -d '|')"; echo
fi
