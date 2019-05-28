#!/bin/bash
# Compare e2e cluster group nodes

POD3Mlist="pe2emulea3300.corp-company.net,pe2emulea3301.corp-company.net"
POD4Mlist="pe2emulea4300.corp-company.net,pe2emulea4301.corp-company.net"

POD1Tlist="psyscommas301.corp-company.net,psyscommas302.corp-company.net"
#POD4Tlist="

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


IFS="\n"

