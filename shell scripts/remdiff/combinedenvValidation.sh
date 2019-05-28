#!/bin/bash

POD3Mlist="pprfmulea3300.corp-company.net,pprfmulea3303.corp-company.net,pprfmulea3301.corp-company.net,pprfmulea3302.corp-company.net,pe2emulea3300.corp-company.net,pe2emulea3301.corp-company.net"
POD4Mlist="pprfmulea4300.corp-company.net,pprfmulea4301.corp-company.net,pprfmulea4302.corp-company.net,pprfmulea4303.corp-company.net,pe2emulea4300.corp-company.net,pe2emulea4301.corp-company.net"

POD3Tlist="pprfcomms304.ie.company,pprfcomms306.ie.company,pprfcomms305.ie.company,pprfcomms307.ie.company,psyscommas301.corp-company.net,psyscommas302.corp-company.net"
POD4Tlist="pprfcomm4300.corp-company.net,pprfcomm4301.corp-company.net"

IFS=","
echo "Validating POD3 Mule servers"
for host in $POD3Mlist
do
#CMPHOST=$host
if [ -n "${TGTHOST}" ]; then
echo "Comparing Configuration Files ${TGTHOST} <=> ${host}"
remdiff-conf.sh -t ${TGTHOST} -c ${host} -A
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
remdiffapp.sh -t ${TGTHOST} -c ${host} -M
echo "---------------------------"
fi
TGTHOST=$host
done

echo "============================"

TGTHOST=""

echo "Validating POD4 Mule Servers"
for host in $POD4Mlist
do

#CMPHOST=$host
if [ -n "${TGTHOST}" ]; then
echo "Comparing Configuration Files ${TGTHOST} <=> ${host} "
remdiff-conf.sh -t ${TGTHOST} -c ${host} -A
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
remdiffapp.sh -t ${TGTHOST} -c ${host} -M
echo "---------------------------"
fi
TGTHOST=$host
done
echo "============================"

TGTHOST=""
echo "Validating POD3 Tomcat Servers"
for host in $POD3Tlist
do
#CMPHOST=$host
if [ -n "${TGTHOST}" ]; then
echo "Comparing Configuration Files ${TGTHOST} <=> ${host}"
remdiff-conf.sh -t ${TGTHOST} -c ${host} -A -T
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
remdiffapp.sh -t ${TGTHOST} -c ${host} -T
echo "---------------------------"
fi
TGTHOST=$host
done
echo "============================"

TGTHOST=""
echo "Validating POD4 Tomcat Servers"
for host in $POD4Tlist
do
#CMPHOST=$host
if [ -n "${TGTHOST}" ]; then
echo "Comparing Configuration Files ${TGTHOST} <=> ${host}"
remdiff-conf.sh -t ${TGTHOST} -c ${host} -A -T
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
remdiffapp.sh -t ${TGTHOST} -c ${host} -T
echo "---------------------------"
fi
TGTHOST=$host
done
echo "============================"


IFS="\n"

