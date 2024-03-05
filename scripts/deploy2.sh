#!/bin/bash

# Variables
APP_NAME="myapplication"
ENV_NAME="my-env"
REGION="us-east-1"
BUCKET_NAME="deploymentfilesbucket"
BUILD_FILE="build.zip"

# Create Elastic Beanstalk application
aws elasticbeanstalk create-application --application-name $APP_NAME --region $REGION


aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION

# Set bucket policy
aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAWSServices",
            "Effect": "Allow",
            "Principal": {
                "Service": "elasticbeanstalk.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::'$BUCKET_NAME'/*"
        }
    ]
}'

# Upload build file to S3
aws s3 cp $BUILD_FILE s3://$BUCKET_NAME/$BUILD_FILE --region $REGION

# Create Elastic Beanstalk environment and deploy build file
aws elasticbeanstalk create-environment --application-name $APP_NAME --environment-name $ENV_NAME --version-label $BUILD_FILE --solution-stack-name "64bit Amazon Linux 2023 v6.1.1 running Node.js 20" --region $REGION