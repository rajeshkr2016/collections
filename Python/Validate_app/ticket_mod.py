import requests
import json
import sys

global ticket
vald_lic = ""
ius_url = 'https://access-e2e.platform.company.net/v2/web/tickets/sign_in'

payload = {
    "password": "xxxxx",
    "username": "qadev+iamtestpass_may-09-15-21-23@gmail.com"
}

# Adding empty header as parameters are being sent in payload
ius_headers = { "accept": "application/json",
    "authorization": "company_IAM_Authentication company_appid=company.appid, company_app_secret=xxxxx",
    "cache-control": "no-cache",
    "Content-Type": "application/json",
    "company_originatingip": "127.0.0.1"
}
r = requests.post(ius_url, data=json.dumps(payload), headers=ius_headers)

try:
        json_data = json.loads(r.content)
#        print json.dumps(json_data, sort_keys=True, indent=4)
# Reading data back
        ticket=json_data['iamTicket']['ticket']
#        print (ticket)
except (ValueError, KeyError, TypeError):
        print "JSON format error:"
