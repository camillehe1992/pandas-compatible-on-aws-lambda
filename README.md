# pandas-compatible-on-aws-lambda

This repo is used to create compatible pandas lambda layers for different AWS Lambda runtime.

Find more details from https://dev.to/camillehe1992/build-lambda-layer-with-pandas-numpy-compatible-for-lambda-runtime-4a4i
## Build a Zip file for Lambda Layer

The relationship among AWS Lambda Runtime, operation system and architecture.

| Lambda Runtime | Operating System | Architectures |
|----------------|------------------|---------------|
| Python 3.7     | Amazon Linux     | x86_64        |
| Python 3.8     | Amazon Linux 2   | x86_64, arm64 |
| Python 3.9     | Amazon Linux 2   | x86_64, arm64 |

Install target python dependencies as you need and archive it as a zip file accroding to above table. For example, create a zip file with dependencies for architecture *x86_64* and python *3.8*. A zip file is created in build folder.

```bash
./build.sh x86_64 3.8

# Output
# Installing collected packages: pytz, tzdata, six, numpy, python-dateutil, pandas
# Successfully installed numpy-1.24.4 pandas-2.0.3 python-dateutil-2.8.2 pytz-2023.3 six-1.16.0 tzdata-2023.3
# ./build/pandas_cp38_manylinux2014_x86_64.zip ok
```
## Create Lambda Layers
Create a lambda layer named *pandas_cp38_manylinux2014_x86_64* with the zip file that created in previous step using AWS CLI.

```bash
# Make sure the AWS credentials is setup on your local
./create-layers.sh pandas_cp38_manylinux2014_x86_64
```

## Create Lambda function
Create a simple lambda function for testing. To create a function, you need a deployment package and an execution role

```bash
# To create a function, you need a deployment package (zip file)
zip ./build/pandas_tester.zip pandas_tester.py


# Create lambda function with python3.8 runtime and arm64 using below command or you can create manually from AWS console.
# Note: you must have a lambda exection role in your AWS account.
aws lambda create-function \
    --function-name pandas-tester-arm64 \
    --runtime python3.8 \
    --zip-file fileb://pandas_tester.zip \
    --handler pandas_tester.lambda_handler \
    --architectures arm64 \
    --role arn:aws-cn:iam::xxxxxxxxxxxx:role/LambdaExecutionRole
```
After function is created successfully, add target lambda layer to the function, and invoke the function using "Test" in function editor.

### Test Result
Below table shows the test result for different scenarios. The **Pass** in the top left corner means a Panda & Numpy packages built in Python 3.7 and x86_64 platform environment is compatiable with AWS Lambda function with Python 3.7 and x86_64 arch. Choose the right python version and platform when installing lambda layer packages according to your lambda functions.


| Lambda Layers                     | x86_64 (default) Python 3.7 | x86_64 (default) Python 3.8 | x86_64 (default) Python 3.9 | arm64 Python 3.7 | arm64 Python 3.8 | arm64 Python 3.9 |
|-----------------------------------|-----------------------------|-----------------------------|-----------------------------|------------------|------------------|------------------|
| pandas_cp37_manylinux2014_x86_64  | **Pass**                    | Failed                      | Failed                      | **Pass**         | Failed           | Failed           |
| pandas_cp37_manylinux2014_aarch64 | Failed                      | Failed                      | Failed                      | Failed           | Failed           | Failed           |
| pandas_cp38_manylinux2014_x86_64  | Failed                      | **Pass**                    | Failed                      | Failed           | **Pass**         | Failed           |
| pandas_cp38_manylinux2014_aarch64 | Failed                      | **Pass**                    | Failed                      | Failed           | Failed           | Failed           |
| pandas_cp39_manylinux2014_x86_64  | Failed                      | Failed                      | **Pass**                    | Failed           | Failed           | **Pass**         |
| pandas_cp39_manylinux2014_aarch64 | Failed                      | Failed                      | Failed                      | Failed           | Failed           | Failed           |