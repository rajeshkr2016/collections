#!/bin/bash

#POD3Mlist="pprdmulea3300.corp-company.net,pprdmulea3301.corp-company.net,pprdmulea3302.corp-company.net,pprdmulea3303.corp-company.net,ppdsmulea3300.corp-company.net,ppdsmulea3301.corp-company.net"
# POD3 Mule Even
POD3Mlist="pprdmulea3300.corp-company.net,pprdmulea3302.corp-company.net,ppdsmulea3300.corp-company.net,ppdsmulea3300.corp-company.net"
# POD4 Mule Even
POD4Mlist="pprdmulea4300.corp-company.net,pprdmulea4302.corp-company.net,ppdsmulea4300.corp-company.net,ppdsmulea4300.corp-company.net"

#POD1TList
#POD1Tlist="pprdcomms304.ie.company,pprdcomms305.ie.company,pprdcomms306.ie.company,pprdcomms307.ie.company"

POD1Tlist="pprdcomms304.ie.company,pprdcomms306.ie.company,ppdscommas301.corp-company.net"
#POD3Tlist="pprdcomm3300.corp-company.net,pprdcomm3301.corp-company.net"
# POD3Tomcat Even
POD3Tlist="pprdcomm3300.corp-company.net,ppdscomm3300.corp-company.net"
#POD4Tlist="pprdcomm4300.corp-company.net,pprdcomm4301.corp-company.net,ppdscomm4302.corp-company.net,pprdmulea4303.corp-company.net"
# POD4 Tomcat
#POD4Tlist="pprdcomm4300.corp-company.net,pprdcomm4401.corp-company.net"
#Even List
POD4Tlist="pprdcomm4300.corp-company.net,ppdscomm4300.corp-company.net"

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
echo "Validating POD1 Tomcat Servers"
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

