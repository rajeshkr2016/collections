#!/bin/bash

PATH=${HOME}/scripts/remdiff/:$PATH

#TGTHOST=$1
#CHOST=$2
#CONFFILE=$3

#diff <(ssh ${APUSER}@${TGTHOST} "cat ${CONFFILE}") <(ssh ${APUSER}@${CHOST} "cat ${CONFFILE}")


#TEMP=$(getopt -o t:c:d: --longoptions=target,chost,dir: --name "$0" -- "$@")
TEMP=$(getopt -o t:c:d:TM --longoptions=target,chost,mule --name "$0" -- "$@")
eval set -- "$TEMP"

TOMCAT="false"
MULE="false"

usage () {
    echo "usage: $0 <-t targethost> <-c comparinghost> <[-d directory-to-compare] [-T(tomcat flag) ] [-M(Mule flag)]>"
    echo "  -t      to specify targethost to compare"
    echo "  -c      to specify comparing host"
    echo "  -d      to specify directory to compare"
    echo "  -T      turn on Tomcat host flag"
    echo "  -M      turn on Mule host flag"
    echo "  This Script will compare between two hosts for its application versions and directory structure based on the specified arguments"
}

if [ "$#" -le 5 ]; then
usage
exit 1
fi

# extract options and their arguments into variables.
while true 
do
    case "$1" in
        -t|--target)
                TGTHOST=$2 
		shift 2
		;;
        -c|--chost) 
		CHOST=$2 ; 
		shift 2
		;;
        -d|--dir)
                DIR=$2 ; 
		shift 2 
		;;
        -T|--tomcat)
		TOMCAT="true"
		shift 1 
		;;
        -M|--mule)
		MULE="true"
		shift 1 
		;;
	--)              # End of all options.
		shift
		break
		;;
        *) 	echo "Internal error!" 
		shift 
		usage
		exit 1
		;;
    esac
done


ENV=${TGTHOST:1:3}

CENV=${CHOST:1:3}

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
elif [[ "$DIR" = *"tomcat"* ]];then
TOMCAT="true"
APUSER="deploy"
PASS="<password>"

elif [[ "$DIR" = *"mule"* ]] || [[ "${TGTHOST}" = *"mule"* ]] && [[ "${CHOST}" = *"mule"* ]] && [ "${ENV}" = "prd" ];then
	MULE="true"
        APUSER="applmgr"
        PASS="<password>"
elif  echo "$TGTHOST"|grep -q "[eE][mM][pP]" && echo "$CHOST"|grep -q "[eE][mM][pP]" ; then
        MULE="true"
        APUSER="applmgr"
        PASS="xxxxx"
else
        echo "Unknown Host types of Host: $TGTHOST and $CHOST"
	exit 1
fi

if [ "$TOMCAT" = "false" ] && [[ "$DIR" = *"mule"* ]] || [[ "${CHOST}" = *"mule"* ]] && [[ "${TGTHOST}" = *"mule"* ]] && [ "${CENV}" = "prd" ];then
        MULE="true"
        CAPUSER="applmgr"
        CPASS="<password>"
        elif  echo "$TGTHOST"|grep -q "[eE][mM][pP]" && echo "$CHOST"|grep -q "[eE][mM][pP]" ; then
        MULE="true"
        CAPUSER="applmgr"
        CPASS="xxxxx"
fi


if [ -z "$DIR" ] && [ "$MULE" = "true" ]; then
SDIR="/mule/mule-ee/apps/"
elif [ -z "$DIR" ] && [ "$TOMCAT" = "true" ]; then
SDIR="/app/tomcat/webapps"
fi

echo "Options: TGTHOST: $TGTHOST; Compare Host: $CHOST; Directory to Compare: ${DIR-Directory not specified. Defaulting to $SDIR}"

DIR=$SDIR

assh.exp ${APUSER}@${TGTHOST} ${PASS} "find $DIR" > tmp/apps-${TGTHOST}.lst
assh.exp ${CAPUSER}@${CHOST} ${CPASS} "find $DIR" > tmp/apps-${CHOST}.lst

bash -c "sdiff -a -b -s -w 250 <(sort tmp/apps-${TGTHOST}.lst) <(sort tmp/apps-${CHOST}.lst)"
appsdircheck=$?

if [ $appsdircheck -eq 0 ]; then
echo -e "\n$TGTHOST has same directory contents: ${DIR} ;Compared Host: ${CHOST}"
else
echo -e "\n$TGTHOST has difference in directory contents: ${DIR} ;Compared Host: ${CHOST}"
fi

if [ "$TOMCAT" = "true" ]; then
assh.exp ${APUSER}@${TGTHOST} ${PASS} "/home/deploy/version.sh" > tmp/apps-ver-${TGTHOST}.txt
assh.exp ${CAPUSER}@${CHOST} ${CPASS} "/home/deploy/version.sh" > tmp/apps-ver-${CHOST}.txt

bash -c "sdiff -a -b -s -w 250 <(sort tmp/apps-ver-${TGTHOST}.txt) <(sort tmp/apps-ver-${CHOST}.txt)"
appsvercheck=$?

if [ $appsvercheck -eq 0 ]; then
echo -e "\n$TGTHOST has same App version; Compared Host: ${CHOST}"
else
echo -e "\n$TGTHOST has different App Versions: ${DIR} ;Compared Host: ${CHOST}"
fi

fi ## Tomcat check
