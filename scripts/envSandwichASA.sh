#!/bin/bash

# Author  : Mark Heckler
# Notes   : Run with 'source envSandwichASA.sh' from your shell/commandline environment
# History : Official "version 1" 20230911.
#         : Option for deploying to both of my accounts; change for yours ;)

# Customize for your environment
# export MH_SUBSCRIPTION=<insert your subscription ID here>

export MH_ROOT_NAME='mh-sw'
export MH_RESOURCE_GROUP=$MH_ROOT_NAME'-rg'
export MH_SPRING_APPS_SERVICE=$MH_ROOT_NAME'-service'
export MH_LOG_ANALYTICS=$MH_ROOT_NAME'-analytics'


export MH_REGION='eastus'
export MH_PROJECT_DIRECTORY=$HOME/dev/scratch/azure
export MH_REPO_OWNER_URI='https://github.com/mkheck'
export MH_PROJECT_REPO='asa-sandwich'
export MH_CONFIG_REPO='sandwich-config'
export MH_CONFIG_DIR='configdir'

# Service/app instances
export MH_GATEWAY_SERVICE_ID='gateway-service'
export MH_STARCH_SERVICE_ID='starch-service'
export MH_TOPPING_SERVICE_ID='topping-service'
export MH_FOOD_SERVICE_ID='food-service'

# Config repo location
# export MH_CONFIG_DIR="$MH_PROJECT_DIRECTORY/source-code/$MH_PROJECT_REPO/config"

# Individual app project directories
export MH_GATEWAY_SERVICE_DIR="$MH_PROJECT_DIRECTORY/$MH_PROJECT_REPO/$MH_GATEWAY_SERVICE_ID"
export MH_STARCH_SERVICE_DIR="$MH_PROJECT_DIRECTORY/$MH_PROJECT_REPO/$MH_STARCH_SERVICE_ID"
export MH_TOPPING_SERVICE_DIR="$MH_PROJECT_DIRECTORY/$MH_PROJECT_REPO/$MH_TOPPING_SERVICE_ID"
export MH_FOOD_SERVICE_DIR="$MH_PROJECT_DIRECTORY/$MH_PROJECT_REPO/$MH_FOOD_SERVICE_ID"

# Deployables
export MH_GATEWAY_SERVICE_JAR="$MH_GATEWAY_SERVICE_DIR/target/$MH_GATEWAY_SERVICE_ID-0.0.1-SNAPSHOT.jar"
export MH_STARCH_SERVICE_JAR="$MH_STARCH_SERVICE_DIR/target/$MH_STARCH_SERVICE_ID-0.0.1-SNAPSHOT.jar"
export MH_TOPPING_SERVICE_JAR="$MH_TOPPING_SERVICE_DIR/target/$MH_TOPPING_SERVICE_ID-0.0.1-SNAPSHOT.jar"
export MH_FOOD_SERVICE_JAR="$MH_FOOD_SERVICE_DIR/target/$MH_FOOD_SERVICE_ID-0.0.1-SNAPSHOT.jar"
