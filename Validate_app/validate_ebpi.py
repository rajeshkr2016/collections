import order
import entitlement
import send_alert

global msg_text

try:
	order.place_order()
	if order.vald_lic:
		vald_lic = order.valdd_lic
		entitlement.send_req(vald_lic)
	if order.msg_text:
        	msg_text = order.msg_text
		send_alert.sendMail(msg_text)

except Exception as ex:
    template = "An exception of type {0} occurred. Arguments:\n{1!r}"
    msg_text = template.format(type(ex).__name__, ex.args)
    print msg_text
    send_alert.sendMail(msg_text)
