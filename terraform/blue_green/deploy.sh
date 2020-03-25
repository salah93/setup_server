#!/bin/bash
set -u

export TF_VAR_do_token=$DO_TOKEN
export TF_VAR_ssh_keys=$DO_SSH_KEYS

export TF_VAR_logserver=$LOGSERVER
export TF_VAR_remote_user=$REMOTE_USER
export TF_VAR_node_count=$NODES
export TF_VAR_size=$SIZE

export NEW_RELEASE=${SHA::10}

printl() {
    echo ===================================================================
    echo                $@
    echo ===================================================================
}

fail() {
    printl 'FAIL - destroying new'
    terraform destroy -auto-approve
    exit
}

if terraform workspace select $NEW_RELEASE >/dev/null 2>&1
then
    export TF_VAR_color=blue
    printl Updating... ${NEW_RELEASE}
else
    terraform workspace new $NEW_RELEASE > /dev/null 2>&1
    export TF_VAR_color=green
    printl Deploying... ${NEW_RELEASE}
fi


# 1. deploy_green
export TF_VAR_release=$NEW_RELEASE
if terraform apply -auto-approve
then
    if ./provision_servers
    then
        printl 'testing...'
        IP_ARR=`terraform output -json ips | jq -r '.[]'`
        for ip in $IP_ARR; do
            output=`curl -s $ip/health`
            printl $output
            if [[ $output != 'OK' ]];
            then
                fail
            fi
        done
    else
        fail
    fi
else
    fail
fi

if [[ $TF_VAR_color == 'green' ]]
then
    # 2. green_to_blue
    printl 'green to blue'
fi

export TF_VAR_color=blue
terraform apply -auto-approve
sleep 30

export OLD_RELEASE=${OLD_SHA::10}
if [[ $OLD_RELEASE != $NEW_RELEASE ]]
then
    if terraform workspace select $OLD_RELEASE >/dev/null 2>&1
    then
        printl destroying old ${OLD_RELEASE}
        # 3. blue_to_green
        export TF_VAR_color=green
        export TF_VAR_release=$OLD_RELEASE
        terraform apply -auto-approve
        sleep 120

        # TODO: schedule this after X minutes
        # 4. destroy_old
        terraform destroy -auto-approve
    fi
fi
