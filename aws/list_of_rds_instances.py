import boto3

rds = boto3.client('rds')
dbs = rds.describe_db_instances()

for db in dbs['DBInstances']:
    print(db)
    print (
    db['MasterUsername'],
    db['Endpoint']['Address'],
    db['Endpoint']['Port'],
    db['DBInstanceStatus']
    )