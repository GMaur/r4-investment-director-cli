#!/bin/bash

set -euo pipefail

### CONFIG
r4automator="localhost:8080"
robot_advisor="localhost:8081"
### END_CONFIG

function create_new_session {
    FOLDER="data/$(date "+%Y-%m-%dT%H%M%S")"
    mkdir -p $FOLDER
    rm -f session
    touch session
    echo "FOLDER=$FOLDER" >> session
    echo "USER=$USER" >> session
}

function read_session {
    file="./session"
    
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
        read -p "Specify the name of the user [ideal]: " USER
        USER=${USER:-ideal}
        create_new_session
        echo "session in $FOLDER"
        ;;
    login )
        echo "if you wish to proceed, go to the IDE to manually confirm this request"
        curl ${r4automator}/login -XPOST -H "Content-Type: application/json" -d '{"username":"AzureDiamond", "password": "hunter2", "nif": "Cthon98"}'
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
    rebalance )
        echo "For manual modifications, please go to ${FOLDER}/portfolio.json and edit the 'cash' section"
        ./join_rebalance_request.sh ${FOLDER}/portfolio.json data/$USER.json > ${FOLDER}/rebalance_request.json
        curl ${robot_advisor}/rebalance -XPOST -H "Content-Type: application/json" --data-binary @${FOLDER}/rebalance_request.json -o ${FOLDER}/rebalance_orders.json
        cat ${FOLDER}/rebalance_orders.json | jq "."
         ;;
    makeoperations )
        echo "if you wish to proceed, go to the IDE to manually confirm this request"
        curl ${r4automator}/operations -XPOST -H "Content-Type: application/json" --data-binary @${FOLDER}/rebalance_orders.json
        ;;
    endsession )
        rm ./session
        ;;
    * )
        echo "could not understand command $1"
        exit 1
esac

exit 0
