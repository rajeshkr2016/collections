import requests
import json
import time 

import sys

msg_text = ""
#global msg_text

vald_lic = ""
app_req = ""

if len(sys.argv) > 1:
	vald_lic = sys.argv[1]

if not vald_lic:
	import order
	if vald_lic:
		vald_lic=order.vald_lic
		ticket=order.ticket
		print "Sleeping 300 seconds"
		time.sleep(300)
	else:
		print "Order placement failed"
		msg_text = "Order placement failed"

print "Checking License:"+vald_lic

app_url = "https://entitlement-e2e.platform.company.net/stg/v1/entitledofferings?licenseId="+vald_lic+"&entitlementId=997094"

ticket = ""
if not ticket:
	import ticket_mod
	ticket=ticket_mod.ticket	

#https://entitlement-e2e.platform.company.net/stg/v1/entitledofferings?licenseId=216966349671344&entitlementId=997094

app_headers = { "accept": "application/json",
    "authorization": "company_IAM_Authentication company_appid=company.appid, company_app_secret=xxxxx, company_userid=xxxx,company_token="+ticket,
    "cache-control": "no-cache",
    "Content-Type": "application/json",
}

payload = {}

def send_req():
	app_req = requests.get(app_url, data=json.dumps(payload), headers=app_headers)
	global entitlement_data
	entitlement_data = ""
        entitlement_data = json.loads(app_req.content)

print(entitlement_data)

try:
	if entitlement_data:
		print json.dumps(entitlement_data, sort_keys=True, indent=4)
# Reading data back
        	enabled_lic = entitlement_data['entitledOfferings'][0]['entitlementInformation']['licenseNumber']
        	print "Enabled License:"+enabled_lic
	else:
		if count < 2:
			count = count + 1
			print "Sleeping 300 more seconds"
        		time.sleep(300)
			send_req()
	print "Failed fetching licenses"
	msg_text = "Failed fetching licenses"
	
except (ValueError, KeyError, TypeError):
        print "JSON format error:"
