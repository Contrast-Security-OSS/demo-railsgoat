#!/bin/sh
set -e 
echo -e "$0: => Running the docker entrypoint script"

function check_agent_connectivity {
    echo -e "$0: => Checking Contrast Agent configuration"
    bundle exec rails contrast:config:validate &> /dev/null
}

if check_agent_connectivity; then
    echo -e "$0: => Contrast agent connectivity check: SUCCESS"
    echo -e "$0: => Starting RailsGoat with Contrast..."
else
    echo -e "$0: => Contrast agent connectivity check: FAILED"
    echo -e "It's likely that you haven't set your Contrast Agent authentication keys correctly."
    echo -e "\nSet the following environment variables by passing them in your docker run command with the -e flag"
    echo -e "\t -e CONTRAST__API__URL="
    echo -e "\t -e CONTRAST__API__API_KEY="
    echo -e "\t -e CONTRAST__API__SERVICE_KEY="
    echo -e "\t -e CONTRAST__API__USER_NAME="
    echo -e "\n OR add these values to the .env file and pass this in your docker command."
    echo -e "\n OR add these values to the contrast_security.yaml file in the config directory."
    echo -e "\nTo find your organization keys please follow this documentation:"
    echo -e "https://docs.contrastsecurity.com/en/find-the-agent-keys.html"
    exit 1
fi

rm -f tmp/pids/server.pid
if [ $TEST ]; then 
    echo -e "== Running RailsGoat in training mode with Contrast enabled =="
    bundle exec rails training
else 
    echo -e "== Running RailsGoat with Contrast enabled =="
    bundle exec rails server -p 3000 -b '0.0.0.0'
fi
