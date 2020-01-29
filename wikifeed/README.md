# How to create a Wikipedia Kinesis stream

1. Create an EC2 instance. Choose the `Amazon AMI` (Not the 2nd generation as it won't have the `aws-kinesis-agent` installed
2. Install the amazon kinesis agent: `sudo yum install aws-kinesis-agent python36-pip`
3. `sudo pip3 install sseclient`
4. `python3 wiki.py | tee -a /tmp/wiki.log`

Then, set up the Kinesis feeder:
 
feeder.json:

```
{
  "cloudwatch.emitMetrics": true,
  "kinesis.endpoint": "https://kinesis.eu-west-1.amazonaws.com",
  "firehose.endpoint": "https://firehose.eu-west-1.amazonaws.com",
  "awsAccessKeyId":"<<ACCESS KEY>>",
  "awsSecretAccessKey":"<<SECRET_KEY>>",
  "checkpointFile": "/home/ec2-user/wikifeed/checkpoint",
  "flows": [
    {
      "filePattern": "/tmp/wiki.log*",
      "kinesisStream": "CEU-Wiki",
      "partitionKeyOption": "RANDOM",
      "maxBufferAgeMillis": 1000,
      "maxBufferSizeRecords": 500,
      "initialPosition": "END_OF_FILE"
    }
  ]
}
```

Start the Kinesis feeder:
`/usr/bin/start-aws-kinesis-agent  -c feeder.json -L INFO -l feeder.log`
