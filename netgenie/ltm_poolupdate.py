import requests
from vipconfig import apikey
import json
import sys
 
def main():
 
    API_Secret_Key = apikey['secret_key']
    header = {'authorization': 'auth_api_secretkey=' + API_Secret_Key + ''}
 
    #Read the file with the VIP names and
    if len(sys.argv) <= 1:
        file_name = input("Enter the file name which contains the VIP List: ").strip()
    else:
        file_name = sys.argv[1]

##Get VIP List from files
    try:
        with open("./"+file_name, "r") as fileObj:
            vip_list = fileObj.readlines()
            fileObj.close()
    except Exception as e:
        print(e)
 
    for vip in vip_list:
        #Get each VIP  Name from the List and pass it to the  the GET method
        r = requests.get("https://netgenie.corp.company.net/ltmapi/v1/virtualserver?vsName="+vip.rstrip()+"-vs_tcp443", headers=header)
#        r = requests.get("https://netgenie.corp.company.net/ltmapi/v1/virtualserver?vsName="+vip.rstrip(), headers=header)
 
        # Converting the output in to JSON Object and storing it ina  variable
        json_obj = r.json()
 
        # Getting the status code and storing in a variable
        status = r.status_code
 
        # Extract the original JSON data to get teh LTM Type
        ltm_type = json_obj["ltm_type"].lower()
 
 
        # Extract the VIP Name and Id
        vServer = json_obj['virtual_server']

        #Check whether the VIP is Internal or External
        pMembers = []
        pMembers = json_obj["default_pool"]["pool_members"]
        #print("pool members" + str(pMembers))
        getnodeIPs = []
        #getnodeState = []
        for memdata in pMembers:
            getnodeIPs.append(memdata["member_ip"])
            print("Member IP:" + memdata["member_ip"])
            print("Member State:" + memdata["pool_member_state"]["state"])
        #getnode_state = poolmembers["member_name"]["state"]
        print("Get Node IPs:" + str(getnodeIPs))
        #Check whether the VIP is Internal or External
        #tls_profile = getTLSProfile(vip_ip)
        #print("JsonObj:" + str(json_obj))
        #print("get nodes" + str(getnodes))
        exit()
 
        if status == 200:
            if ltm_type == "f5":
                # Extracting the Virtual Server Profile to get the SSL Profile and storing it in variable
                memberstat = json_obj["virtual_server_profiles"][0]["parent_profile"].split("/")
                # Getting the last element from the List
                memberstat_name = memberstat[len(memberstat) - 1]
 
                profile_type = "ssl client profile"
 
                profile_name = json_obj["virtual_server_profiles"][0]["profile_name"]
 
                parent_profile = "/Common/"+tls_profile+""
 
            elif ltm_type == "avi":
                # Extracting the Virtual Server Profile to get the SSL Profile and storing it in variable
                #memberstat_name = json_obj["ssl_parent_profile"]
                memberstat_name = json_obj["virtual_server_profiles"][1]["profile_name"]
 
                profile_type = "SSL PROFILE"
 
                profile_name = tls_profile
 
                parent_profile = tls_profile
 
            else:
                print("Unknown VIP")
                break
 
            #Comparing if the SSL Profile name is old
            if memberstat_name != tls_profile:
                print("You are running older Chiper Profile for the VIP: {}, you need to update to TLS 1.2 Profile only setting".format(vServer))
                print("Going to update this VIP: {} with the new TLS 1.2 Profile".format(vServer))
                json_data = formatRequestData(vServer, profile_type, profile_name, parent_profile)
                output = updateVip(json_data, header)
                print(output)
            else:
                print("You are already running the latest TLS 1.2 Profile on {} ..You are Good".format(vServer))
        else:
            print("Error in getting the VIP details for {}".format(vip))

def enablePoolMember(vServer)
    enbReq=formatRequestData(vServer,vServerIP)
    
 
#Function to create teh JSON data based on the VIP Type
def formatRequestDataiEnable(vServer, vServerIP):
    json_update = {
        "virtual_server": vServer,
        "default_pool": [{
	"pool_name": vServer+"-pool>",
	"pool_members": [{
         "member_ip": "<vServer-IP>",
         "pool_member_state": {
          "state": "Enabled",
        }
	
    }
    return json_update
 
# Check whether the VIP is Internal or External
def getmemnodes(poolmembers):
    pool_members = json.dumps(poolmembers)
    #getnodes = pool_members["member_name"]["availability"]
    #getnode_state = pool_members["member_name"]["state"]
    #return getnode_state
 
#Function to update the VIP
def updateVip(json_data, header):
    u = requests.put("https://netgenie.corp.company.net/ltmapi/v1/virtualserver/",json=json_data, headers=header)
    return u.text
 
 
if __name__== "__main__":
  main()
 
