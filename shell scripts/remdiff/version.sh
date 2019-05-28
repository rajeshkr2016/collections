#!/bin/bash
#
####################################################################
#                                                                   
# Get Tomcat app versions by Senthil Arumugam in Jan, 2016			
#                                                                   
####################################################################
#
TOMCAT_APP_HOME=/app/tomcat/webapps
#
# Below prints the tomcat version numbers
#
echo "TOMCAT APP VERSIONS"
echo " "
cd "$TOMCAT_APP_HOME"
grep -r version= | grep pom.properties | awk -F'[/=]' '{ print $1, "\t", $NF }'

