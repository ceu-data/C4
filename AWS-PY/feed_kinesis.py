import sys
import socket
import random

import boto3
from botocore.errorfactory import ClientError

def get_sensor_data_flow():
    """Connects to the Datapao PowerPlant server and
       reads the sensor data record by record in json"""
    TCP_HOST = "spark.datapao.com"
    TCP_PORT = 2732
    BUFFER_SIZE = 1024
    
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((TCP_HOST, TCP_PORT))
        while True:
            data = s.recv(BUFFER_SIZE)
            yield data[:-1] # Remove newline

stream_name = 'zolidevstream'
boto3.setup_default_session(region_name='us-east-1') # N. Virginia
session = boto3.Session()
credentials = session.get_credentials()

kinesis = boto3.client('kinesis')

try:
   stream = kinesis.describe_stream(StreamName=stream_name)
   if stream['StreamDescription']['StreamStatus'] != 'ACTIVE':
       print('ERROR: Stream {} is not in ACTIVE state. Perhaps just starting?\n\n{}'.format(stream_name, stream))
       sys.exit(2)
except ClientError as e:
    if e.response['Error']['Code'] == 'ResourceNotFoundException':
        print('ERROR: Stream with name {} not found.'.format(stream_name), file=sys.stderr)
        sys.exit(1)
    else:
        raise e

print("SUCCESS: Found stream {}".format(stream_name))

for payload in get_sensor_data_flow():
    # Simply put a data to a random partition. We will actually only have one single partition.
    kinesis.put_record(
        StreamName=stream_name,
        Data=payload,
        PartitionKey=str(random.randint(1,10)))
    print("sending to {}: {}".format(stream_name, payload))

