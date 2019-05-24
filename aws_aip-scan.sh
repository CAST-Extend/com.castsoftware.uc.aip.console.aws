console_base_url=${console_base_url:-http://ec2-100-25-182-57.compute-1.amazonaws.com:8081}
# GET token and cookies
cookies=$(set -o pipefail; curl --connect-timeout 1 --max-time 3 -s -I -u cast:cast -XGET "$console_base_url"/api/user | sed -n -E 's/^Set-Cookie: (.*;) Path=.*$/\1/p' | paste -s -d ' ')
if (( $? != 0 ))
then
  printf "Fail to login with base url '%s'. Please check its availability.\n" "$console_base_url"
  exit 1
fi
printf "Cookies %s" "$cookies"; echo

#curl -s -u cast:cast -X GET --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2)" --header 'Content-Type: application/json' --header 'Accept: application/json' "$console_base_url"/api/ | python -mjson.tool

#curl -u cast:cast -X PUT --header 'Cookie: {{cookie.stdout}}' --header 'X-XSRF-TOKEN: {{cookie.stdout.split(' ')[0].split('=')[1][:-1]}}' --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"database":{"host":"{{aip_postgres_ip}}","port":5432,"userName":"operator","password":"CastAIP"},"schemaName":"general_measure"}' 'http://localhost:8081/api/settings/measurement-settings'

# create application

get_nodes() {
  curl -s -u cast:cast -X GET --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2)" --header 'Content-Type: application/json' --header 'Accept: application/json' "$console_base_url"/api/nodes | python -mjson.tool
}

get_applications() {
  curl -s -u cast:cast -X GET --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2)" --header 'Content-Type: application/json' --header 'Accept: application/json' "$console_base_url"/api/applications | python -mjson.tool
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



func=$1; shift
if declare -F | cut -d ' ' -f3 | grep -q "^${func}$"
then
  $func "$@"
else
  printf "Usage : $0 %s" "$(declare -F | cut -d ' ' -f3 | paste -s -d '|')"; echo
fi
