#!/bin/sh

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/create-function.html

# To create a function, you need a deployment package and an execution role

zip ./build/pandas_tester.zip pandas_tester.py

aws lambda create-function \
    --function-name pandas-tester-arm64 \
    --runtime python3.8 \
    --zip-file fileb://pandas_tester.zip \
    --handler pandas_tester.lambda_handler \
    --architectures arm64 \
    --role arn:aws-cn:iam::xxxxxxxxxxxx:role/LambdaExecutionRole

aws lambda create-function \
    --function-name pandas-tester-x86_64 \
    --runtime python3.8 \
    --zip-file fileb://build/pandas_tester.zip \
    --handler pandas_tester.lambda_handler \
    --architectures x86_64 \
    --role arn:aws-cn:iam::xxxxxxxxxxxx:role/LambdaExecutionRole
