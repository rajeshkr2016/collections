#!/bin/bash

POD3Mlist="pprdmulea3300.corp-company.net,pprdmulea3301.corp-company.net,pprdmulea3302.corp-company.net,pprdmulea3303.corp-company.net,pprdmulea3400.corp-company.net,pprdmulea3401.corp-company.net,pprdmulea3402.corp-company.net,pprdmulea3403.corp-company.net"
POD4Mlist="pprdmulea4300.corp-company.net,pprdmulea4301.corp-company.net,pprdmulea4302.corp-company.net,pprdmulea4303.corp-company.net,pprdmulea4401.corp-company.net,pprdmulea4402.corp-company.net,pprdmulea4403.corp-company.net"

POD3Tlist="pprdcomm3300.corp-company.net,pprdcomm3301.corp-company.net"
POD1Tlist="pprdcomms304.ie.company,pprdcomms305.ie.company,pprdcomms306.ie.company,pprdcomms307.ie.company"
POD4Tlist="pprdcomm4300.corp-company.net,pprdcomm4301.corp-company.net,pprdcomms404.ie.company,pprdcomms405.ie.company,pprdcomms406.ie.company,pprdcomms407.ie.company,pprdcomm4400.corp-company.net,pprdcomm4401.corp-company.net"
POD5Tlist="pprdcomm5300.corp-company.net,pprdcomm5301.corp-company.net"

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
for host in $POD1Tlist
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

TGTHOST=""
echo "Validating POD5 Tomcat Servers"
for host in $POD5Tlist
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

