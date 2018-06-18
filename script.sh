#!/bin/bash

set -euo pipefail

### CONFIG
r4automator="localhost:8080"
robot_advisor="localhost:8081"
### END_CONFIG

session="./session"

function create_new_session {
    FOLDER="data/$(date "+%Y-%m-%dT%H%M%S")"
    mkdir -p $FOLDER
    rm -f "$session"
    touch "$session"
    echo "FOLDER=$FOLDER" >> "$session"
    echo "USER=$USER" >> "$session"
}

function read_session {
    file="$session"
    
    if [ -f "$file" ]
    then
      while IFS='=' read -r key value
      do
        eval "${key}='${value}'"
      done < "$file"
    else
      echo "$file not found."
    fi
}

read_session

set -e
case "$1" in
    newsession )
        default_user="ideal"
        read -p "Specify the name of the user [$default_user]: " USER
        USER=${USER:-$default_user}
        create_new_session
        echo "session for user $USER in $FOLDER"
        ;;
    login )
        echo "if you wish to proceed, go to the IDE to manually confirm this request"
        curl ${r4automator}/login -XPOST -H "Content-Type: application/json" -d '{"username":"AzureDiamond", "password": "hunter2", "nif": "Cthon98"}' > $FOLDER/login.html
        if [ $? -eq 0 ]; then
            echo "Login was ok"
        else
            echo "Error with log in - see $FOLDER/login.html"
        fi
        ;;
    2fa )
        ./2fa.sh ;;
    scrape )
        curl ${r4automator}/scrapes/cash -o $FOLDER/cash.html
        curl ${r4automator}/scrapes/funds -o $FOLDER/funds.html
        ;;
    parseportfolio )
        curl ${r4automator}/parse -XPOST -F "funds=@${FOLDER}/funds.html" -F "cash=@${FOLDER}/cash.html" | jq "." > ${FOLDER}/portfolio.json
        cat ${FOLDER}/portfolio.json | jq "."
        ;;
    prepare-contribution )
        cat ${FOLDER}/portfolio.json | jq '.assets[] | select(.type|contains ("cash"))' > ${FOLDER}/cash.json
        cat ${FOLDER}/cash.json | jq "."
        echo "For manual modifications, please go to ${FOLDER}/cash.json and edit the value"
        ;;
    contribute )
        echo "For manual modifications, please go to ${FOLDER}/cash.json and edit the value"
        ./join_contribute_request.sh ${FOLDER}/cash.json data/$USER.json | jq "." > ${FOLDER}/contribute_request.json
        curl ${robot_advisor}/contribute -XPOST -H "Content-Type: application/json" --data-binary @${FOLDER}/contribute_request.json -o ${FOLDER}/new_orders.json
        cat ${FOLDER}/new_orders.json | jq "."
        ;;
    rebalance )
        echo "For manual modifications, please go to ${FOLDER}/portfolio.json and edit the 'cash' section"
        ./join_rebalance_request.sh ${FOLDER}/portfolio.json data/$USER.json > ${FOLDER}/rebalance_request.json
        curl ${robot_advisor}/rebalance -XPOST -H "Content-Type: application/json" --data-binary @${FOLDER}/rebalance_request.json -o ${FOLDER}/new_orders.json
        cat ${FOLDER}/rebalance_orders.json | jq "."
         ;;
    makeoperations )
        echo "if you wish to proceed, go to the IDE to manually confirm this request"
        curl ${r4automator}/operations -XPOST -H "Content-Type: application/json" --data-binary @${FOLDER}/new_orders.json > ${FOLDER}/operations_result.html
        if [ $? -eq 0 ]; then
            echo "Making the operations was ok"
        else
            echo "Error with making the operations - see ${FOLDER}/operations_result.html or the IDE"
        fi
        ;;
    endsession )
        rm ./"$session"
        ;;
    * )
        echo "could not understand command $1"
        exit 1
esac

exit 0
