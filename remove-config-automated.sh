#!/usr/bin/bash

# Ensure the correct environment variables are set
# ORG_NAME: Will be used in https://dev.azure.com/<ORG_NAME>
# CLIENT_ID: The client ID of the service principal
# CLIENT_SECRET: The client secret of the service principal
# TENANT_ID: The tenant id which the service prinipal was created
# AGENT_POOL_NAME: The name of the agent pool which the service principal is an adminstrator over (set at the org level).

# source environment variables from agent_details.sh if present
source ./agent_details.sh
export AGENT_ALLOW_RUNASROOT=true
set -u

expect <<EOF
    ################################################################################
    # Start the program you want to interact with
    ################################################################################
    spawn ./config.sh remove

    ################################################################################
    # Service prinicpal authentication
    ################################################################################
    expect "Enter authentication type (press enter for PAT) > "
    send "sp\r"

    ################################################################################
    # App registration client id
    ################################################################################
    expect "Enter Client(App) ID > "
    send "${CLIENT_ID}\r"

    ################################################################################
    # Tenant id of app registration
    ################################################################################
    expect "Enter Tenant ID > "
    send "${TENANT_ID}\r"

    ################################################################################
    # App registration secret
    ################################################################################
    expect "Enter Client secret > "
    send "${CLIENT_SECRET}\r"

    expect 'done!'
EOF


