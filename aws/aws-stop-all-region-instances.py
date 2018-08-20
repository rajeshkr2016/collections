import boto3
import boto3.ec2
import boto
import sys
from boto.ec2.connection import EC2Connection

client = boto3.client('ec2', region_name='us-east-1')

ec2_regions = [region['RegionName'] for region in client.describe_regions()['Regions']]


for region in ec2_regions:
    conn = boto3.resource('ec2', region_name=region)
    instances = conn.instances.filter()
    for instance in instances:
         instanceList = []
         ec2 = boto3.resource( 'ec2', region_name=region)
         #print (instanceList)
         if instance.state["Name"] == "running":
              instanceList.append(instance.id)
              status = ec2.instances.filter(InstanceIds=instanceList).stop()
import aws_get_all_region_instances
         #print (instance.id, status, instance.instance_type, region)
