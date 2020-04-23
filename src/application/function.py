import logging
import boto3
import json
import os
import itertools

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):

    logger.info("START Dataet processor function")

    # Get dataset from S3 and convert JSON to Dictionary
    s3 = boto3.resource('s3')
    content_object = s3.Object(os.environ['S3_DATASET_BUCKET'], os.environ['S3_DATASET_BUCKET_KEY'])
    file_content = content_object.get()['Body'].read().decode('utf-8')
    json_content = json.loads(file_content)

    # First get list of instances from list of Reservations. Result will be list of list instances.
    # Second take list of list instances and merge into list of instances, where each instance is a dictionary.
    result = list(itertools.chain.from_iterable(list(map(lambda x: x['Instances'], json_content['Reservations']))))

    if event['pathParameters'] is not None and 'InstanceId' in event['pathParameters']:
        result = list(filter(lambda d: d["InstanceId"] == event['pathParameters']['InstanceId'], result))

    # If there are no Result return 204 (No Content), otherwise 200 with content.
    # In any other bad scenarios API Gateway and Lambda will return other codes like 403 or 500
    return {
        "body": None if result == [] else json.dumps(result),
        "statusCode": 204 if result == [] else 200,
        "isBase64Encoded": False
    }
