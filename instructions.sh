########## STEPS TO RUN ##########
sudo apt-get update && sudo apt-get install -y expect
curl -sSL "https://vstsagentpackage.azureedge.net/agent/4.248.1/vsts-agent-linux-x64-4.248.1.tar.gz" -o azdo-agent.tar.gz && mkdir azdo-agent && mv azdo-agent.tar.gz azdo-agent && cd azdo-agent && tar -xzvf azdo-agent.tar.gz && rm azdo-agent.tar.gz
./bin/installdependencies.sh
export AGENT_ALLOW_RUNASROOT=true
# copy file add-config-automates.sh
# copy file agent_details.sh
chmod a+x ./add-config-automated.sh && ./add-config-automated.sh -n "testing_agent" -w "/testing_workingdirectory"
./run.sh

########## STEPS TO STOP ##########
# copy file remove-config-automated.sh
chmod a+x ./remove-config-automated.sh && ./remove-config-automated.sh

