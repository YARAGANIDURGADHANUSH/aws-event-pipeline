def lambda_handler(event, context):
    print("New file uploaded to S3")
    print(event)

    return {
        "statusCode": 200,
        "message": "Data processed successfully"
    }
