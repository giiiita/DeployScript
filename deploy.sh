#!/bin/bash

function main() {
    local DEPLOY_TARGET=`firebase target`
    if echo $DEPLOY_TARGET | grep "production"; then
        echo "Do you want to deploy in a production environment?(y/n)"
        read answer
        case $answer in
            y | Y)
                select_deploy_part
            ;;
            n | N)
                echo "bye!"
            ;;
        esac    
    else
        select_deploy_part
    fi
}

function check_target_function() {
    echo "If you want to deploy only a specific function, please enter the function name"
    echo "If you press Enter without input, all functions will be deployed"
    read function_name
    if [ $function_name ]; then
        firebase deploy --only functions:$function_name
    else
        firebase deploy --only functions
    fi
}

function start_deploy() {
    case $1 in
        firestore:rules | hosting)
            firebase deploy --only $1
        ;;
        functions)
            check_target_function
        ;;
        all)
            firebase deploy
        ;;
        *)
            echo "bye"
        ;;
    esac
}

function select_deploy_part() {
    echo "Please select the target number you want to deploy"
    local PART_LIST="firestore:rules hosting functions all"
    select selection in $PART_LIST
    do
          if [ $selection ]; then
                  start_deploy $selection
            break
          else
            echo "invalid selection."
            echo "bye!"
            break
          fi
    done
}

main
