import requests
import json
import time 

import sys

msg_text = ""
#global msg_text
global ticket
global app_url
global vald_lic
vald_lic = ""
app_req = ""

ticket = ""

def send_req(vald_lic):
	if not ticket:
		import ticket_mod
		ticket=ticket_mod.ticket
	app_url = "https://entitlement-e2e.platform.company.net/stg/v1/entitledofferings?licenseId="+vald_lic+"&entitlementId=997094"
	app_headers = { "accept": "application/json",
    		"authorization": "company_IAM_Authentication company_appid=company.appid, company_app_secret=xxxxxxxxxxxxx, company_userid=xxxxx,company_token="+ticket,
    		"cache-control": "no-cache",
    		"Content-Type": "application/json",
	}
	payload = {}
	print "app_url:"+app_url
	print "Payload"
	print payload
	print "headers="
	print app_headers
	app_req = requests.get(app_url, data=json.dumps(payload), headers=app_headers)
        entitlement_data = json.loads(app_req.content)
	count=0

	try:
		print json.dumps(entitlement_data, sort_keys=True, indent=4)
# Reading data back
        	enabled_lic = entitlement_data['entitledOfferings'][0]['entitlementInformation']['licenseNumber']
        	print "Enabled License:"+enabled_lic

	except ValueError:
		msg_text = "Failed fetching licenses due to ValueError"
		print "JSON format error."+msg_text

#	except IndexError:
#		if count < 2:
#			count = count + 1
#			print "Sleeping 300 more seconds"
#        		time.sleep(300)
#			#send_req()
#		else:
#			print "Failed fetching licenses"
#			msg_text = "Failed fetching licenses"
#		msg_text = "Failed fetching licenses due to IndexError"
#        	print "Null Response Received Exception type: "+msg_text

	except Exception as ex:
    		template = "An exception of type {0} occurred. Arguments:\n{1!r}"
    		msg_text = template.format(type(ex).__name__, ex.args)
    		print msg_text
	print "Entitlement data:"
	print(entitlement_data)
	print "----------------"



