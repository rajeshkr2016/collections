# Import smtplib for the actual sending function
import smtplib
import sys

# Import the email modules we'll need
from email.mime.text import MIMEText

# me == the sender's email address
# you == the recipient's email address

# Send the message via our own SMTP server, but don't include the
# envelope header.

def sendMail(msg_text):
	msg = MIMEText(msg_text+"\r\nPlease check Order processing or DB Sync with Siebel DB")
	me = "rajesh_radhakrishnan@company.com"
	you = "rajesh_radhakrishnan@company.com"
	
	msg['From'] = me
	msg['To'] = you
	msg['Subject'] = "Validation failed"

	try:
		s = smtplib.SMTP('mailout.data.ie.company.net')
		s.sendmail(me, [you], msg.as_string())
		s.quit()
	except Exception as e:
		print "Exception: ",e

msg_text = "Failure"

try:
		msg_text = sys.argv[1]
		sendMail(msg_text)
except IndexError:
		print "No Message text to input"
        	exit
except Exception as e:
		print "Exception: ",e	
#		msg_text = "Validation failed due to one of the failures in integration components"
