#!/bin/bash
# Author: Rajesh Radhakrishnan
# Usage: ./remdiff.sh -e qal -t pqalmulea3300.corp-company.net -E prf -c pprfmulea3301.corp-company.net -f '/mule/mule-ee/conf/webs-mule-global-qal.properties'
# Description:
#  This script compares two files between two servers (of different environments either in PROD or NON-Prod) and shows any differences using diff utility
#  - Auto Logins to any environment and fetches files to compare
#  - Uses expect scripting (TCL scripting) technique to automatically login to any server using applmgr/ deploy user
#  - identifies environment based on the file server name or specified environment in script arguments
#
# --Pre requisites---
#   - ascp.exp (expect script) file should be present in the same folder as script directory or specifiied in the PATH variable below
#   - expect program based on TCL language should be present in the server where the script is used
#   - openssh should be present too
#   - User id and password should be set according to PROD or NON-Prod Environment details in the script variable

PATH=${HOME}/scripts/remdiff/:$PATH

TOMCAT="false"
MULE="false"
ALLFLAG="fale" 

usage () {
    echo "usage: $0 <-t targethost> <-c comparinghost> < [-f file-to-compare] [-T(tomcat flag) ] [-A (All configuration files to compare)] >"
    echo "  -t      to specify targethost to compare"
    echo "  -c      to specify comparing host"
    echo "  -f      to specify file to compare"
    echo "  -T      turn on Tomcat host flag"
    echo "  -A      turn on All configuration files comparison flag to check files in /app/tomcat/conf/ or /mule/mule-ee/conf/"
    echo "  This Script will compare between two hosts and its text files based on the specified arguments"
}

if [ "$#" -lt 5 ]; then
usage
exit 1
fi

TEMP=$(getopt -o e:t:E:c:f:T,A --longoptions=target,chost,file:,tomcat,all-conf-files --name "$0" -- "$@")
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true 
do
    case "$1" in
        -e|--env)
                ENV=$2 
		shift 2
		;;
        -t|--target)
                TGTHOST=$2 
		shift 2
		;;
        -E|--Env) 
		CENV=$2 ; 
		shift 2
		;;
        -c|--chost) 
		CHOST=$2 ; 
		shift 2
		;;
        -f|--file)
                CONFFILE=$2 ; 
		shift 2 
		;;
        -T|--tomcat)
                TOMCAT="true" ; 
		shift  
		;;
        -A|--all-conf-files)
                ALLFLAG="true" ; 
		shift  
		;;
	--)              # End of all options.
		shift
		break
		;;
        *) 	echo "Internal error!" 
		shift 2
		exit 1
		;;
    esac
done

#CONFFILE=${FILE}

if [ "$TOMCAT" = "true" ]; then
APUSER="deploy"
PASS="<password>"
elif [[ "$CONFFILE" = *"tomcat"* ]];then
TOMCAT="true"
APUSER="deploy"
PASS="<password>"
elif [[ "$CONFFILE" = *"mule"* ]];then
MULE="true"
APUSER="applmgr"
PASS="xxxxx"
elif  echo "$TGTHOST"|grep -q "[eE][mM][pP]" && echo "$CHOST"|grep -q "[eE][mM][pP]"; then
MULE="true"
APUSER="applmgr"
PASS="xxxxx"
fi

if [ -z "$ENV" ]; then
ENV=${TGTHOST:1:3}
fi

if [ -z "$CENV" ]; then
CENV=${CHOST:1:3}
fi

DCNAME="qydc"

echo "Options: Target Host: $TGTHOST; Compare Host: $CHOST; Environment: $ENV and $CENV"
# check if it is for one conf file comparison or multiple

if [ -n "$CONFFILE" ]; then
if [ "$ENV" != "$CENV" ]; then
CCONFFILE=${CONFFILE}
if [[ $CONFFILE = *"$ENV"* ]]; then
CCONFFILE=`echo $CONFFILE|sed 's/'$ENV'/'$CENV'/'`
fi
fi

echo "Comparing Hosts: $TGTHOST <=> $CHOST;Configuration file: $CONFFILE <=> $CCONFFILE"

FNAME1=${CONFFILE##*/}
FNAME2=${CCONFFILE##*/}

ascp.exp ${APUSER}@${TGTHOST}:${CONFFILE} ${PASS} tmp/${TGTHOST}-${FNAME1} 1> /dev/null 2>&1
ascp.exp ${APUSER}@${CHOST}:${CCONFFILE} ${PASS} tmp/${CHOST}-${FNAME2} 1> /dev/null 2>&1

bash -c "sdiff -b -s -w 250 <(sort tmp/"${TGTHOST}-${FNAME1}") <(sort tmp/"${CHOST}-${FNAME2}")"
if [ $? -eq 0 ]; then
echo "$TGTHOST has same file contents: ${CONFFILE} ;Compared Host: ${CHOST} file: "
else
echo "$TGTHOST has different file contents: ${CONFFILE} ;Compared Host: ${CHOST}"
fi

else
echo "Comparing Hosts: $TGTHOST <=> $CHOST;Configuration file: All Configuration Files"
if [ "$TOMCAT" = "true" ] && [ "$ALLFLAG" = "true" ]; then

if [ "${ENV}" = "sys" ]; then
ENV="e2e"
fi
if [ "${CENV}" = "sys" ]; then
CENV="e2e"
fi
assh.exp ${APUSER}@${TGTHOST} ${PASS} "cat /app/tomcat/conf/global-application-${ENV}.properties /app/tomcat/conf/global-passwords-${ENV}.properties" > tmp/${TGTHOST}-tomcat.properties
assh.exp ${APUSER}@${CHOST} ${PASS} "cat /app/tomcat/conf/global-application-${CENV}.properties /app/tomcat/conf/global-passwords-${CENV}.properties" > tmp/${CHOST}-tomcat.properties

bash -c "sdiff -b -s -w 250 <(sort "tmp/${TGTHOST}-tomcat.properties") <(sort "tmp/${CHOST}-tomcat.properties")"
if [ "$?" -eq 0 ]; then
echo "No difference between compared hosts for files: tmp/${TGTHOST}-tomcat.properties tmp/${CHOST}-tomcat.properties"
else
echo "Differences in conf files found: tmp/${TGTHOST}-tomcat.properties tmp/${CHOST}-tomcat.properties"
fi

elif [ "$MULE" = "true" ] && [ "$ALLFLAG" = "true" ]; then
assh.exp ${APUSER}@${TGTHOST} ${PASS} "cat /mule/mule-ee/conf/webs-mule-global-${ENV}.properties /mule/mule-ee/conf/webs-mule-${DCNAME}-${ENV}.properties /mule/mule-ee/conf/webs-mule-${ENV}-password.properties" > tmp/${TGTHOST}-mule.properties
assh.exp ${APUSER}@${CHOST} ${PASS} "cat /mule/mule-ee/conf/webs-mule-global-${CENV}.properties /mule/mule-ee/conf/webs-mule-${DCNAME}-${CENV}.properties /mule/mule-ee/conf/webs-mule-${CENV}-password.properties" > tmp/${CHOST}-mule.properties
bash -c "sdiff -b -s -w 250 <(sort tmp/${TGTHOST}-mule.properties) <(sort tmp/${CHOST}-mule.properties)"
if [ "$?" -eq 0 ]; then
echo "No difference between compared hosts for files: tmp/${TGTHOST}-mule.properties tmp/${CHOST}-mule.properties"
else
echo "Differences in conf files found: tmp/${TGTHOST}-mule.properties tmp/${CHOST}-mule.properties"
fi
fi

fi
