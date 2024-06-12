
#!/bin/bash

# Usage:
# 1) . ./aws-assume-role.sh <deployment_account> <deployment_role>

assume_role() {
    credentials=$(aws sts assume-role --role-arn arn:aws:iam::${1}:role/${2} --duration-seconds 3600 --role-session-name ${1}-${2}-$(date "+%Y%m%d_%H%M%S"))
    if [ "$credentials" ]; then
        export AWS_ACCESS_KEY_ID=$(echo ${credentials} | jq -r .Credentials.AccessKeyId)
        export AWS_SECRET_ACCESS_KEY=$(echo ${credentials} | jq -r .Credentials.SecretAccessKey)
        export AWS_SESSION_TOKEN=$(echo ${credentials} | jq -r .Credentials.SessionToken)
        echo "Assume Role Successful! Account: '${1}' Role: '${2}'"
        aws sts get-caller-identity | cat
    fi
}

if [ ! -z "$1" ] && [ ! -z "$2" ]; then
    assume_role "$1" "$2"
fi