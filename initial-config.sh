# Get key
set -x
server=ec2-18-209-225-90.compute-1.amazonaws.com:8081

curl -vv -c /tmp/aip-cookies.txt -X GET "http://$server/api/initial-config/key" -H "accept: application/json" 

curl -vv -b /tmp/aip-cookies.txt -X POST "http://$server/api/initial-config" -H "accept: application/json"  -H "Content-Type: application/json" \
  -H "X-XSRF-TOKEN: $(grep XSRF /tmp/aip-cookies.txt | cut -f7)" \
  -d @aip_console_init-config-payload.json 

