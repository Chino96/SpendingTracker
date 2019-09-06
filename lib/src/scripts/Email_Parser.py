import imaplib
import email
import json
import re

"""
This script is highly specialized because of the nature of the
data that is being read in. The bank used does not have an api
for transaction data. However an alternative is created using an
email service provided by the bank.
"""

"""
Summary:
    function to be called by REST API that searches the email inbox
    for mail and returns a dictionary of transactions.

Params:
    String: month
                month of data to search for.
"""
def fetch_email(month='01'):
        #use Imaplib to connect to email imap via ssl
		mail = imaplib.IMAP4_SSL('IMAP.SOME-EMAIL-IMAP.com')
		#execute login using email address and password
		mail.login('EMAIL@EMAIL.COM', 'PASSWPRD')
		#select an inbox
		mail.select('SOME-INBOX')

        #search through all mail and store data in data variable
		type, data = mail.search(None, 'ALL')
		#store 0th index of the data which contains the ids of each email
		mail_ids = data[0]
		#split ids into a list
		id_list = mail_ids.split()

		#start ids of objects to be stored in JSON at 0
		id = 0
		#Initialize empty JSON list
		json_list = []

        #loop through each email(future implementations will us np array [where] method to minimize runtime)
		for i in range(0, len(id_list)):
		    #fetch data from email
			typ, dta = mail.fetch(str(int(id_list[i])), '(RFC822)')
            #store email message raw data and parse it to a string
			msg = email.message_from_bytes(dta[0][1])
			message = str(msg)

            #retrive message body
			body = message[message.index('Card'):message.index('For transaction')-1]

            #parse body into a list based on spaces and new lines
			body_as_list = re.split('\n |\s', body)

            #initialize empty dictionary to place values
			body_dictionary = {}

            #store id of current item (index starts at 0)
			body_dictionary['id'] = id
			#retrive card data (specialized may not work for every email)
			body_dictionary['Card'] = body_as_list[14]
			try:
			    #retrive the location and merchant
				body_dictionary['Merchant'] = " ".join(body_as_list[22:body_as_list.index('Date')]).split('in ')[0]
				body_dictionary['Location'] = " ".join(body_as_list[22:body_as_list.index('Date')]).split('in ')[1]

			except:
			    #unique edge cases apply: sometimes location my not be available
			    body_dictionary['Location'] = "NO LOCATION AVAILABLE"
				body_dictionary['Merchant'] = " ".join(body_as_list[22:body_as_list.index('Date')])

            #retrive amount and date
			body_dictionary['Ammount'] = float(body_as_list[17])
			body_dictionary['Date'] = body_as_list[-2]

            """
            Conditionals used to determine the type(category)
            of each transaction. These are not applicable
            to any case, they are made specifically for a
            previous transaction history.
            """
			if 'GEICO' in body_dictionary['Merchant'] or 'GEORGIA POWER' in body_dictionary['Merchant']:
				body_dictionary['Type'] = 0

			elif 'Microsoft' in body_dictionary['Merchant'] or 'Xbox' in body_dictionary['Merchant'] or 'XBOX' in body_dictionary['Merchant'] or 'MICROSOFT' in body_dictionary['Merchant'] or 'YMCA' in body_dictionary['Merchant']:
				body_dictionary['Type'] = 1

			elif 'CHEVRON' in body_dictionary['Merchant'] or 'ADVANCE AUTO' in body_dictionary['Merchant']:
				body_dictionary['Type'] = 2

			else:
				body_dictionary['Type'] = 3

            #conditional to determine if the requested month aligns with the month of the email
			if body_dictionary['Date'].startswith(month):
			    #add transaction json body
				json_list.append(body_dictionary)
				#increment the id
	            id++


        #dump list into actual json
		email_json = json.dumps(json_list)

		return email_json
