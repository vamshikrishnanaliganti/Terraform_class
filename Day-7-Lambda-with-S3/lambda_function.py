# import json
# import boto3

# def lambda_handler(event,context):
# # Initialize the EC2 client
#     client = boto3.client('ec2')
 
#     response = ec2.run_instances(
#         ImageId='ami-019374baf467d6601',  # Replace with a valid AMI ID, specific to the region
#         InstanceType='t2.micro',
#         KeyName='LondonKP',              # Replace with your key pair name for that region
#         MinCount=1,
#         MaxCount=1
#     )
