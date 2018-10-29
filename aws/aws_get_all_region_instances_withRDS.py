import boto3


client = boto3.client('ec2', region_name='us-east-1')

ec2_regions = [region['RegionName'] for region in client.describe_regions()['Regions']]

for region in ec2_regions:
    conn = boto3.resource('ec2',region_name=region)
    instances = conn.instances.filter()
    for instance in instances:
#        if instance.state["Name"] == "running":
            print (instance.id, instance.state["Name"], instance.instance_type, region)


rds = boto3.client('rds')
rds_regions=[region['RegionName'] for region in rds.describe_regions()['Regions']]

try:
# get all of the db instances

    for rdsreg in rds_regions:
        dbs = rds.describe_db_instances()
        for db in dbs['DBInstances']:
            print(
                db['MasterUsername'],
                db['Endpoint']['Address'],
                db['Endpoint']['Port'],
                db['DBInstanceStatus']
            )
except Exception as error:
    print (error)