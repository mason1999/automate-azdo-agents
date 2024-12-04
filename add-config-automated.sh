#!/usr/bin/bash

# Ensure the correct environment variables are set
# ORG_NAME: Will be used in https://dev.azure.com/<ORG_NAME>
# CLIENT_ID: The client ID of the service principal
# CLIENT_SECRET: The client secret of the service principal
# TENANT_ID: The tenant id which the service prinipal was created
# AGENT_POOL_NAME: The name of the agent pool which the service principal is an adminstrator over (set at the org level).

# source environment variables from agent_details.sh if present. If not ensure that environment variables are set
source ./agent_details.sh
export AGENT_ALLOW_RUNASROOT=true
set -u

agent_name=""
work_folder=""

while getopts 'n:w:' option; do
    case "${option}" in
        (n)
            agent_name="${OPTARG}"
            ;;
        (w)
            work_folder="${OPTARG}"
            ;;
        (?)
    esac
done

if [[ -z "${agent_name}" ]]; then
    echo -e "\e[93mPlease provide a value to the -n parameter to name your new agent.\e[97m"
    echo -e "\e[93mFor example: ${0} -n my_new_agent.\e[97m"
    exit 1
fi

if [[ -z "${work_folder}" ]]; then
    echo -e "\e[93mPlease provide a value to the -w parameter to specify the work folder for your new agent.\e[97m"
    echo -e "\e[93mFor example: ${0} -w _my_work or ${0} -w testing_work.\e[97m"
    exit 1
fi

expect <<EOF
    ################################################################################
    # Start the program you want to interact with
    ################################################################################
    spawn ./config.sh --auth sp

    ################################################################################
    # Accept the terms of service
    ################################################################################
    expect "Enter (Y/N) Accept the Team Explorer Everywhere license agreement now? (press enter for N) > "
    send "Y\r"

    ################################################################################
    # Azure DevOps organisation
    ################################################################################
    expect "Enter server URL > "
    send "https://dev.azure.com/${ORG_NAME}\r"

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

    ################################################################################
    # Agent pool name
    ################################################################################
    expect "Enter agent pool (press enter for default) > "
    send "${AGENT_POOL_NAME}\r"

    ################################################################################
    # Agent name
    ################################################################################
    expect -re "Enter agent name.*"
    send "${agent_name}\r"

    ################################################################################
    # Work folder
    ################################################################################
    expect -re "Enter work folder.*"
    send "${work_folder}\r"

    expect 'done!'
EOF

