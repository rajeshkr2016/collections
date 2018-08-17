#!/bin/bash

POD3Mlist="pqalmulea3300.corp-company.net,pqalmulea3301.corp-company.net"
POD4Mlist="pqalmulea4300.corp-company.net,pqalmulea4301.corp-company.net"

POD1Tlist="pqalcommas301.corp-company.net,pqalcommas302.corp-company.net"
#POD4Tlist="

IFS=","
echo "Validating POD3 Mule servers"
for host in $POD3Mlist
do
#CMPHOST=$host
if [ -n "${TGTHOST}" ]; then
echo "Comparing Configuration Files ${TGTHOST} <=> ${host}"
./remdiff-conf.sh -t ${TGTHOST} -c ${host} -A 
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
./remdiffapp.sh -t ${TGTHOST} -c ${host} -M
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
./remdiff-conf.sh -t ${TGTHOST} -c ${host} -A
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
./remdiffapp.sh -t ${TGTHOST} -c ${host} -M
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
./remdiff-conf.sh -t ${TGTHOST} -c ${host} -A -T
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
./remdiffapp.sh -t ${TGTHOST} -c ${host} -T
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
./remdiff-conf.sh -t ${TGTHOST} -c ${host} -A -T
echo "---------------------------"
echo "Comparing App Versions and directory structure ${TGTHOST} <=> ${host}"
./remdiffapp.sh -t ${TGTHOST} -c ${host} -T
echo "---------------------------"
fi
TGTHOST=$host
done
echo "============================"


IFS="\n"

