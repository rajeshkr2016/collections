#!/bin/bash

POD3Mlist="ppdsmulea3300.corp-company.net,ppdsmulea3301.corp-company.net"
POD4Mlist="ppdsmulea4300.corp-company.net,ppdsmulea4301.corp-company.net"

POD3Tlist="ppdscomm3300.corp-company.net,ppdscomm3301.corp-company.net"
POD4Tlist="ppdscomm4300.corp-company.net,ppdscomm4301.corp-company.net"

IFS=","
TGTHOST=""
host=""
echo "Validating POD3 Mule servers"
for host in $POD3Mlist
do
#CMPHOST=$host
if [ -n "${TGTHOST}" ]; then
echo "Comparing Configuration Files ${TGTHOST} <=> ${host}"
bash -c "./remdiff.sh -t ${TGTHOST} -c ${host} -A"
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
bash -c "./remdiffapp.sh -t ${TGTHOST} -c ${host} -M"
echo "---------------------------"
fi
TGTHOST=$host
done

echo "============================"

TGTHOST=""
host=""

echo "Validating POD4 Mule Servers"
for host in $POD4Mlist
do

#CMPHOST=$host
if [ -n "${TGTHOST}" ]; then
echo "Comparing Configuration Files ${TGTHOST} <=> ${host} "
bash -c "./remdiff.sh -t ${TGTHOST} -c ${host} -A"
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
bash -c "./remdiffapp.sh -t ${TGTHOST} -c ${host} -M"
echo "---------------------------"
fi
TGTHOST=$host
done
echo "============================"

TGTHOST=""
host=""
echo "Validating POD3 Tomcat Servers"
for host in $POD3Tlist
do
#CMPHOST=$host
if [ -n "${TGTHOST}" ]; then
echo "Comparing Configuration Files ${TGTHOST} <=> ${host}"
bash -c "./remdiff.sh -t ${TGTHOST} -c ${host} -A -T"
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
bash -c "./remdiffapp.sh -t ${TGTHOST} -c ${host} -T"
echo "---------------------------"
fi
TGTHOST=$host
done
echo "============================"

TGTHOST=""
host=""
echo "Validating POD4 Tomcat Servers"
for host in $POD4Tlist
do
#CMPHOST=$host
if [ -n "${TGTHOST}" ]; then
echo "Comparing Configuration Files ${TGTHOST} <=> ${host}"
bash -c "./remdiff.sh -t ${TGTHOST} -c ${host} -A -T"
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
bash -c "./remdiffapp.sh -t ${TGTHOST} -c ${host} -T"
echo "---------------------------"
fi
TGTHOST=$host
done
echo "============================"


IFS="\n"

