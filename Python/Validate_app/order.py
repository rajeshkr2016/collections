import requests
import json
import ticket_mod


global vald_lic
global ticket

global ius_url
global app_url
ius_url = 'https://access-e2e.platform.company.net/v2/web/tickets/sign_in'
app_url = "https://order-e2e.platform.company.net/stg/v1/orders"

def place_order():
#https://entitlement-e2e.platform.company.net/stg/v1/entitledofferings?licenseId=xxxxxx&entitlementId=xxxxx
	ticket = ticket_mod.ticket
	app_headers = { "accept": "application/json",
    	"Accept-Encoding": "UTF-8",
    	"authorization": "company_IAM_Authentication company_appid=company.appid, company_app_secret=xxxxxxx, company_userid=xxxxxxx,company_token="+ticket,
    	"Content-Type": "application/xml"
	}

	with open('orderfile.xml', 'r') as orderfile:
    		payload = orderfile.read().replace('$', '')

	print "Ticket: "+ticket
	app_req = requests.post(app_url, data=payload, headers=app_headers)

	try:
        	order_data = json.loads(app_req.content)
		order_number = order_data['orderNumber']
	# Reading data back
        	vald_lic = order_data['orderLines']['orderLines'][0]['entitlement']['licenseNumber']['value']
        	print "Order submitted with Order Number: "+order_number+ "/ License:"+vald_lic
	except (ValueError, KeyError, TypeError):
        	print "JSON format error:"
		msg_text = "JSON Response Unknown error"

#place_order()
