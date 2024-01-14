# alfabet_ori_exercise

This repository implements a RESTful API that manages events, offering users the ability to schedule, retrieve,
update, delete, and be reminded of events with additional advanced features.
The components used are:

* Terraform to create the backend infrastructure
* AWS S3 + DynamoDB to hold the Terraform state file
* AWS IAM roles for authentication (one role to create the infrastructure, one role to access the api)
* AWS Lambda function to run the code (Python)
* PostgresSQL with AWS RDS to store events data

*NOTE: this is an initial version, for a more scalable solution you'd need to use ALB, WAF, and several more modifications.

### Getting started
##### 1. Before starting you'll need to have the following AWS prerequisites:
- AN AWS account with an IAM user credentials (don't user your root user!)
- AWS CLI installed on your local machine
- An AWS IAM user without access to the console and with an access key that can be used with AWS CLI.
- Save the user access key in AWS secrets manager for future access, you'll need it soon to authenticate Terraform before assuming the role.

##### 2. Create a role to be assumed by Terraform: 
On the AWS IAM console, create a new role named 'iac-role' with 'PowerUserAccess' permissions. This role will be temporarily be assumed by Terraform to create or modify backend items for you.

##### 3. Attach the managed policy *PowerUserAccess* to the IAM role and the following trust policy:



    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Statement1",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "<CLI_USER_ARN>"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }

replace <CLI_USER_ARN> with the user you created for CLI actions


##### 4. Create a new IAM policy with these permissions, and attach it For the IAM user:

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AssumeRole1",
                "Effect": "Allow",
                "Action": ["sts:AssumeRole"],
                "Resource": ["<IAC_ROLE_ARN>"]
            }
        ]
    }

replace <IAC_ROLE_ARN> with the role you created for terraform to assume when creating or modifying your backend infrastructure

##### 5. Configure your AWS CLI:
in VS code, open a terminal and type 'aws configure'. The terminal will then ask for your AWS Access Key ID, AWS Secret Access Key, Default region name (us-east-1), Default output format (leave empty, None).

##### 6. Create a backend state management for Terraform:
Run the following lines:
replace <IAC_ROLE_ARN> with the role you created for terraform to assume when creating or modifying your backend infrastructure

    cd tf_backend
    terraform init
    terraform plan -var="role_arn=<IAC_ROLE_ARN>"
    terraform apply -var="role_arn=<IAC_ROLE_ARN>"

Then type 'yes' for it to run

And finally you'll get the value of the output strings 'tfstr1_init', 'tfstr2_apply'. Copy the values, you'll need it in a bit. 

### So far for the first time.
To create or modify your backend infrastructure run the following line:

    cd ../tf_main

Then, paste in the terminal the string 'tfstr1_init' and after it completes paste in the string 'tfstr2_apply'
In the output' you'll see al the details you will need to access the API.
And you're ready to go!

    
