import requests
import time
from vipconfig import apikey
import socket
import sys

API_Secret_Key = apikey['secret_key']
headers = {'authorization': 'auth_api_secretkey='+API_Secret_Key+''}

def main():
    #Get the VIP name/list from the User
    #Read the file with the VIP names
    #Read the file with the VIP names and
    if len(sys.argv) <= 1:
        file_name = input("Enter the file name which contains the VIP List: ").strip()
    else:
        file_name = sys.argv[1]

    try:
#        file_name = input("Enter the file name which contains the VIP List: ").strip()
        with open("./"+file_name, "r") as fileObj:
            vip_list = fileObj.readlines()
    except Exception as e:
        print(e)

    for vip in vip_list:
        vsname = vip.rstrip('\n')+"-vs_tcp443"
        #r =  getVIPDetails(vip, headers)
        r =  getVIPDetails(vsname, headers)
        json_obj = r.json()
        status = r.status_code

        # Check if the return code is Success
        if status == 200:
            # Extract the VIP Name from the JSON Object
            vServer = json_obj['virtual_server']
            vServer_state = json_obj['virtual_server_state']['state']
            vServer_id = json_obj['virtual_server_id']
            print("VIP: {}, Status: {} ".format(vServer, vServer_state))

            # Extract only the LTM Reals from the JSON Object
            pool_name = json_obj['default_pool']['pool_name']
            ltm_members = json_obj['default_pool']['pool_members']

            # Declare a empty list for capturing VIP/Pool Members
            vip_reals = []

            for members in ltm_members:
                member_ip = members['member_ip']
                member_name = members['member_name']
                (real_name, _, _) = socket.gethostbyaddr(member_ip)
                member_port = members['pool_member_config']['service_port']
                member_availability = members['pool_member_state']['availability']
                member_state = members['pool_member_state']['state']
                member_status = "Real IP/Hostname: {}/{}, Port: {}, Availability: {}, Status: {}".format(member_ip,real_name,member_port,member_availability,member_state)
                vip_reals.append(member_name)

                # Print the Real Ip, Port, Availability and State
                print(member_status)


            # Check if you want to enable/disable the VIP
            q1 = input("Do you want to enable or disable this VIP (enable/disable/skip)? : ").strip().lower()

               if q1 == "enable" or q1 == "disable":
                   print("We are going to {} the member IP:"+member_ip+".....".format(q1))
                   # Develop the code to update the VIP
                   json_data1 = formatVIPData(vServer, vServer_id, q1)
                   output1 = updatePool(json_data1, headers)
                   print(output1['status_message'])
               else:
                   print("We have not changed the VIP Status: {}...Skipping".format(vServer))


            # Check if you want to enable/disable the Pool Members
            q2 = input("Do you want to enable or disable Reals/Members of this VIP (enable/disable/quit)? : ").strip().lower()

            if q2 == "enable" or q2 == "disable":
                print("We are going to {} the Members/Reals......".format(q2))
                # Declare a empty list to for a PUT request
                update_reals = []
                # Here we will check the members that are in Offline state and create a response in JSON format
                for memb in vip_reals:
                    real_details = {
                        "member_name": memb,
                        "pool_member_state": {
                            "state": q2
                        }
                    }
                    update_reals.append(real_details)

                # Develop the code to update the VIP to enable/disable Real's
                json_data2 = formatRealData(vServer, vServer_id, pool_name, update_reals)
                output2 = updatePool(json_data2, headers)
                print(output2['status_message'])
            else:
                print("We have not changed the state of Members/Reals of this VIP: {}..Exiting the Program".format(vServer))

        else:
            # Otherwise print on the screen that the User entered value is not correct
            print("The Entered VIP {} is not correct or valid".format(vsname))


#To create the JSON data for Pool Mmber/Real update
def formatRealData(vServer, vServer_id, pool_name, update_reals):
    json_update = {
        "virtual_server_id": vServer_id,
        "virtual_server": vServer,
        "default_pool": {
        "pool_name": pool_name,
        "pool_members": update_reals
        }
    }
    return json_update

#To create the JSON data for VIP update
def formatVIPData(vServer, vServer_id, vip_state):
    json_update = {
        "virtual_server_id": vServer_id,
        "virtual_server": vServer,
        "virtual_server_state": {
        "state": vip_state
        }
    }
    return json_update

# To get the details of teh VIP
def getVIPDetails(vip_name,header):
    r = requests.get("https://netgenie.corp.company.net/ltmapi/v1/virtualserver?vsName=" + vip_name, headers=header)
    return r


# To Update the VIP Pool/Members
def updatePool(data, headers):
    u = requests.put("https://netgenie.corp.company.net/ltmapi/v1/virtualserver/", json=data, headers=headers)
    return u.json()


if __name__== "__main__":
    main()
