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

TEMP=$(getopt -o e:t:E:c:f:T,A,M --longoptions=target,chost,file:,tomcat,all-conf-files,mule --name "$0" -- "$@")
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
        -M|--mule)
                MULE="true" ; 
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
if [ -z "$ENV" ]; then
ENV=${TGTHOST:1:3}
fi

if [ -z "$CENV" ]; then
CENV=${CHOST:1:3}
fi

if [ "$TOMCAT" = "true" ]; then
APUSER="deploy"
PASS="<password>"

CAPUSER="deploy"
CPASS="<password>"
elif [[ "$CONFFILE" = *"tomcat"* ]];then
TOMCAT="true"
APUSER="deploy"
PASS="<password>"

elif  [[ "$CONFFILE" = *"mule"* ]]  && [ "${ENV}" = "prd" ];then
	MULE="true"
	APUSER="applmgr"
	PASS="<password>"
elif  echo "$TGTHOST"|grep -q "[eE][mM][pP]" && echo "$CHOST"|grep -q "[eE][mM][pP]" && [ "${ENV}" = "prd" ] ; then
	MULE="true"
	APUSER="applmgr"
        PASS="<password>"		
elif  echo "$TGTHOST"|grep -q "[eE][mM][pP]" && echo "$CHOST"|grep -q "[eE][mM][pP]" ; then
	MULE="true"
	APUSER="applmgr"
	PASS="xxxxx"
fi

if [ "$TOMCAT" = "false" ] & [[ "$CONFFILE" = *"mule"* ]]  && [ "${CENV}" = "prd" ];then
        MULE="true"
        CAPUSER="applmgr"
        CPASS="<password>"
elif  echo "$TGTHOST"|grep -q "[eE][mM][pP]" && echo "$CHOST"|grep -q "[eE][mM][pP]" && [ "${CENV}" = "prd" ] ; then
        MULE="true"
        CAPUSER="applmgr"
        CPASS="<password>"
elif  echo "$TGTHOST"|grep -q "[eE][mM][pP]" && echo "$CHOST"|grep -q "[eE][mM][pP]" ; then
        MULE="true"
        CAPUSER="applmgr"
        CPASS="xxxxx"
fi

if [ ! -d "tmp/${TGTHOST}" ]; then
mkdir tmp/${TGTHOST}
else
rm -rf tmp/${TGTHOST}
mkdir tmp/${TGTHOST}
fi

if [ ! -d "tmp/${CHOST}" ]; then
mkdir tmp/${CHOST}
else
rm -rf tmp/${CHOST}
mkdir tmp/${CHOST}
fi

if echo "$TGTHOST"|grep -q "[3-4]3[0-9][0-9]"; then
DCNAME="qydc"
elif echo "$TGTHOST"|grep -q "[3-4]4[0-9][0-9]"; then
DCNAME="lvdc"
fi

if echo "$CHOST"|grep -q "[3-4]3[0-9][0-9]"; then
CDCNAME="qydc"
elif echo "$CHOST"|grep -q "[3-4]4[0-9][0-9]"; then
CDCNAME="lvdc"
fi


if [ "$ENV" = "sys" ]; then
ENV="e2e"
fi
if [ "$CENV" = "sys" ]; then
CENV="e2e"
fi


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
ascp.exp ${CAPUSER}@${CHOST}:${CCONFFILE} ${CPASS} tmp/${CHOST}-${FNAME2} 1> /dev/null 2>&1


bash -c "sdiff -b -s -w 250 <(sort tmp/"${TGTHOST}-${FNAME1}") <(sort tmp/"${CHOST}-${FNAME2}")"
if [ $? -eq 0 ]; then
echo "$TGTHOST has same file contents: ${CONFFILE} ;Compared Host: ${CHOST} file: "
else
echo "$TGTHOST has different file contents: ${CONFFILE} ;Compared Host: ${CHOST}"
fi

else
echo "Comparing Hosts: $TGTHOST <=> $CHOST;Configuration file: All Configuration Files"
if [ "$TOMCAT" = "true" ] && [ "$ALLFLAG" = "true" ]; then


ascp.exp "${APUSER}@${TGTHOST}:/app/tomcat/conf/global-*-${ENV}.properties" ${PASS} tmp/${TGTHOST}/ 1> /dev/null 2>&1
ascp.exp "${CAPUSER}@${CHOST}:/app/tomcat/conf/global-*-${CENV}.properties" ${CPASS} tmp/${CHOST} 1> /dev/null 2>&1

bash -c "sdiff -b -s -w 250 <(sort "tmp/${TGTHOST}/global-application-${ENV}.properties") <(sort "tmp/${CHOST}/global-application-${CENV}.properties")"
APROPSTATUS=$?
bash -c "sdiff -b -s -w 250 <(sort "tmp/${TGTHOST}/global-passwords-${ENV}.properties") <(sort "tmp/${CHOST}/global-passwords-${CENV}.properties")"
if [ "$?" -eq 0 ] && [ "${APROPSTATUS}" -eq 0 ] ; then
echo "No difference between compared hosts for files: tmp/${TGTHOST}/{global-application-${ENV}.properties,global-passwords-${ENV}.properties} and tmp/${CHOST}/{global-application-${CENV}.properties,global-passwords-${CENV}.properties}"
else
echo "Differences in conf files found: tmp/${TGTHOST}/global-*-${ENV}.properties and tmp/${CHOST}/global-*-${ENV}.properties"
fi

elif [ "$MULE" = "true" ] && [ "$ALLFLAG" = "true" ]; then
if [ "$ENV" = "pds" ]; then
ENV="stg"
fi

if [ "$CENV" = "pds" ]; then
CENV="stg"
fi

ascp.exp "${APUSER}@${TGTHOST}:/mule/mule-ee/conf/webs-mule-*${ENV}*.properties" ${PASS} tmp/${TGTHOST}/ 1> /dev/null 2>&1
ascp.exp "${CAPUSER}@${CHOST}:/mule/mule-ee/conf/webs-mule-*${CENV}*.properties" ${CPASS} tmp/${CHOST}/ 1> /dev/null 2>&1
echo "Comparing tmp/${TGTHOST}/webs-mule-global-${ENV}.properties and tmp/${CHOST}/webs-mule-global-${CENV}.properties"
bash -c "sdiff -b -s -w 250 <(sort tmp/${TGTHOST}/webs-mule-global-${ENV}.properties) <(sort tmp/${CHOST}/webs-mule-global-${CENV}.properties)"
PROP1STAT=$?
echo "===================================================================================================================="
echo -e "\nComparing tmp/${TGTHOST}/webs-mule-${DCNAME}-${ENV}.properties and tmp/${CHOST}/webs-mule-${CDCNAME}-${CENV}.properties"
bash -c "sdiff -b -s -w 250 <(sort tmp/${TGTHOST}/webs-mule-${DCNAME}-${ENV}.properties) <(sort tmp/${CHOST}/webs-mule-${CDCNAME}-${CENV}.properties)"
PROP2STAT=$?
echo "===================================================================================================================="
echo -e "\nComparing tmp/${TGTHOST}/webs-mule-${ENV}-password.properties and tmp/${CHOST}/webs-mule-${CENV}-password.properties"
bash -c "sdiff -b -s -w 250 <(sort tmp/${TGTHOST}/webs-mule-${ENV}-password.properties) <(sort tmp/${CHOST}/webs-mule-${CENV}-password.properties)"
PROP3STAT=$?
echo "===================================================================================================================="

if [ "$PROP1STAT" -eq 0 ] && [ "$PROP2STAT" -eq 0 ] && [ "$PROP3STAT" -eq 0 ]; then
echo "No difference between compared hosts for files: tmp/${TGTHOST}/{webs-mule-global-${ENV}.properties,webs-mule-${DCNAME}-${ENV}.properties,webs-mule-${ENV}-password.properties} and tmp/${CHOST}/{webs-mule-global-${CENV}.properties,webs-mule-${CDCNAME}-${CENV}.properties,webs-mule-${CENV}-password.properties}"
else
echo "Differences in conf files found: tmp/${TGTHOST}/{webs-mule-global-${ENV}.properties,webs-mule-${DCNAME}-${ENV}.properties,webs-mule-${ENV}-password.properties} and tmp/${CHOST}/{webs-mule-global-${CENV}.properties,webs-mule-${CDCNAME}-${CENV}.properties,webs-mule-${CENV}-password.properties}"
fi
fi

fi
