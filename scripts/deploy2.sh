#!/bin/bash

# Variables
APP_NAME="myapplication"
ENV_NAME="my-env"
REGION="us-east-1"
BUCKET_NAME="deploymentfilesbucket"
BUILD_FILE="build.zip"



# # Set bucket policy


# Upload build file to S3
aws s3 cp ../$BUILD_FILE s3://$BUCKET_NAME/$BUILD_FILE || echo "An error occurred while copying the file to s3 bucket: $?" >&2

# Create Elastic Beanstalk application
aws elasticbeanstalk create-application --application-name $APP_NAME --region $REGION || echo "An error occurred while creating beanstalk app: $?" >&2

# Create Elastic Beanstalk environment and deploy build file
aws elasticbeanstalk create-environment --application-name $APP_NAME --environment-name $ENV_NAME --version-label $BUILD_FILE --solution-stack-name "64bit Amazon Linux 2023 v6.1.1 running Node.js 20" --region $REGION || echo "An error occurred while creating the beanstalk environment: $?" >&2