#!/usr/bin/env python3
#  -*- coding: utf-8 -*-

import argparse, sys, boto3, pprint

session = boto3.Session()

regions = session.get_available_regions('ec2')

for region in regions:
    if (region!='us-west-2'):
        continue
    print("Region: " + region)

    ec2client = session.client('ec2', region)
    rdsclient = session.client('rds', region)

    instances = {}
    dbs = {}

    #ec2_instances = ec2client.describe_instances(Filters=[ { 'Name': 'instance-state-name', 'Values': [ 'running' ] } ])
    ec2_instances = ec2client.describe_instances()
    print(ec2_instances)
    for reservation in ec2_instances['Reservations']:
        for instance in reservation['Instances']:
            instance_name =	instance['InstanceId']
            PrivateIpAddress = instance['PrivateIpAddress']
        if 'Tags' in dict.keys(instance):
            for tag in instance['Tags']:
                if tag['Key'] == 'Name':
                    instance_name =	instance['InstanceId'] + ' (' +	tag['Value'] + ')'
        if instance['VpcId'] in instances:
                instances[instance['VpcId']].append(instance_name)
                #instances[instance['VpcId']].append(ip)
        else:
                inst_name = []
                inst_name.append(instance_name)
                instances[instance['VpcId']] = [instance_name]
                instances[instance['VpcId']].append(PrivateIpAddress )
    db_instances = rdsclient.describe_db_instances()
    #print(db_instances)
    for db_instance in db_instances['DBInstances']:
        if 'DBSubnetGroup' in db_instance:
            #print(db_instance)
            db_vpc = db_instance['DBSubnetGroup']['VpcId']
            #print(db_vpc)
            if db_vpc in dbs:
                dbs[db_vpc].append(db_instance['DBInstanceIdentifier'])
            else:
                dbs[db_vpc] = [ db_instance['DBInstanceIdentifier'] ]
        #print(dbs[db_vpc])
    vpcs = ec2client.describe_vpcs()
    #print(vpcs)
    for vpc in vpcs['Vpcs']:
        #if vpc['IsDefault'] == False:
        vpc_id = vpc['VpcId']
        if 'Tags' in dict.keys(vpc):
            for tag in vpc['Tags']:
                if tag['Key'] == "Name":
                    vpc_name = tag['Value']
        print('\033[1;32;40m' + vpc_id + ' | ' + ' | ' + vpc['CidrBlock'] + ' (' + str(len(instances))  + ' ec2 instances, ' + str(len(dbs)) + ' rds instances)\033[0;37;40m')
        if vpc_id in instances:
            print('\033[1;33;40m    ec2 instances: \033[0;37;40m' + ','.join(instances[vpc_id])+ '\033[1;35;40m IP: \033[0;37;40m' )
        if vpc_id in dbs:
            print('\033[1;35;40m    rds instances: \033[0;37;40m' + ','.join(dbs[vpc_id]) + '\033[1;35;40m IP: \033[0;37;40m')