import boto3
import boto3.ec2
import boto
from boto.ec2.connection import EC2Connection

client = boto3.client('ec2', region_name='us-east-1')

ec2_regions = [region['RegionName'] for region in client.describe_regions()['Regions']]


for region in ec2_regions:
    conn = boto3.resource('ec2', region_name=region)
    instances = conn.instances.filter()
    for instance in instances:
         instanceList = []
         ec2 = boto3.resource( 'ec2', region_name=region)
         instanceList.append(instance.id)
         #print (instanceList)
#        if instance.state["Name"] == "running":
              status = ec2.instances.filter(InstanceIds=instanceList).stop()
         #print (instance.id, status, instance.instance_type, region)

import aws-get-all-region-instances.py
