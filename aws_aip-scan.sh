console_base_url=http://ec2-100-25-182-57.compute-1.amazonaws.com:8081
# GET token and cookies
cookies=$(curl -s -I -u cast:cast -XGET "$console_base_url"/api/user | sed -n -E 's/^Set-Cookie: (.*;) Path=.*$/\1/p' | paste -s -d ' ')


curl -s -u cast:cast -X GET --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2)" --header 'Content-Type: application/json' --header 'Accept: application/json' "$console_base_url"/api/ | python -mjson.tool
curl -s -u cast:cast -X GET --header "Cookie: $cookies" --header "X-XSRF-TOKEN: $(echo $cookies | cut -d ' ' -f1 | cut -d '=' -f2)" --header 'Content-Type: application/json' --header 'Accept: application/json' "$console_base_url"/api/applications | python -mjson.tool

#curl -u cast:cast -X PUT --header 'Cookie: {{cookie.stdout}}' --header 'X-XSRF-TOKEN: {{cookie.stdout.split(' ')[0].split('=')[1][:-1]}}' --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"database":{"host":"{{aip_postgres_ip}}","port":5432,"userName":"operator","password":"CastAIP"},"schemaName":"general_measure"}' 'http://localhost:8081/api/settings/measurement-settings'



