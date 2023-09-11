#!/bin/bash
# set -e

# Author  : Mark Heckler
# Notes   : Must have sourced envSandwichASA.sh before this script per envSandwichASA.sh instructions
# History : Official "version 1" 20230911.
#         : 

function error_handler() {
  az group delete -g $MH_RESOURCE_GROUP --no-wait --subscription $MH_SUBSCRIPTION -y
  echo "ERROR occurred :line no = $2" >&2
  exit 1
}
trap 'error_handler $? ${LINENO}' ERR

clear

# Add required extensions
az extension add -n spring


# Set origin machine variable (if desired/required)
# DEVBOX_IP_ADDRESS=$(curl ifconfig.me)


# Create and sanitize local code directory
cd $MH_PROJECT_DIRECTORY

mkdir -p source-code
cd source-code
rm -rdf $MH_PROJECT_REPO


# Retrieve code from repo, build apps
printf "\n\nCloning the sample project: $MH_REPO_OWNER_URI/$MH_PROJECT_REPO\n"

git clone --recursive $MH_REPO_OWNER_URI/$MH_PROJECT_REPO
cd $MH_PROJECT_REPO
mvn clean package -DskipTests -Denv=cloud

cd "$MH_PROJECT_DIRECTORY/source-code/$MH_PROJECT_REPO"


# Infra configuration
printf "\n\nCreating the Resource Group: $MH_RESOURCE_GROUP Region: $MH_REGION\n"
# printf "\n\nCreating the Resource Group: ${MH_RESOURCE_GROUP} Region: ${MH_REGION}\n"

az group create -l $MH_REGION -g $MH_RESOURCE_GROUP --subscription $MH_SUBSCRIPTION


printf "\n\nCreating the Spring Apps infra: $MH_SPRING_APPS_SERVICE\n"

# --disable-app-insights is likely superfluous per 
# https://docs.microsoft.com/en-us/cli/azure/spring-cloud?view=azure-cli-latest#az-spring-cloud-create
az spring create -n $MH_SPRING_APPS_SERVICE -g $MH_RESOURCE_GROUP -l $MH_REGION --disable-app-insights false
# --subscription $SUBSCRIPTION

# az spring config-server set --config-file $CONFIG_DIR/application.yml -n $SPRING_APPS_SERVICE -g $RESOURCE_GROUP
# OR
# az spring config-server git set -n $MH_SPRING_APPS_SERVICE -g $MH_RESOURCE_GROUP --uri $MH_REPO_OWNER_URI/$MH_CONFIG_REPO
az spring config-server git set -n $MH_SPRING_APPS_SERVICE -g $MH_RESOURCE_GROUP --uri $MH_REPO_OWNER_URI/$MH_PROJECT_REPO --search-paths $MH_CONFIG_DIR


# Create app constructs in ASA
printf "\n\nCreating the apps in Spring Apps\n"

az spring app create -n $MH_GATEWAY_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
    --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
az spring app create -n $MH_STARCH_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
    --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
az spring app create -n $MH_TOPPING_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
    --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
az spring app create -n $MH_FOOD_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
    --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true

# # Create app deployment constructs in ASA, another idiotic middle ground step to waste time with no default
# printf "\n\nCreating the app deployments in Spring Apps\n"
# az spring app deployment create -n $MH_GATEWAY_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
#     --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
# az spring app deployment create -n $MH_STARCH_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
#     --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
# az spring app deployment create -n $MH_TOPPING_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
#     --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
# az spring app deployment create --app $MH_FOOD_SERVICE_ID -n production -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
#     --instance-count 1 --memory 2Gi --runtime-version Java_17

# Log analysis configuration
printf "\n\nCreating the log analytics workspace: $MH_LOG_ANALYTICS\n"

az monitor log-analytics workspace create -g $MH_RESOURCE_GROUP -n $MH_LOG_ANALYTICS -l $MH_REGION
                            
MH_LOG_ANALYTICS_RESOURCE_ID=$(az monitor log-analytics workspace show \
    -g $MH_RESOURCE_GROUP \
    -n $MH_LOG_ANALYTICS --query id --output tsv)

MH_WEBAPP_RESOURCE_ID=$(az spring show -n $MH_SPRING_APPS_SERVICE -g $MH_RESOURCE_GROUP --query id --output tsv)


printf "\n\nCreating the log monitor\n"

az monitor diagnostic-settings create -n "send-spring-logs-and-metrics-to-log-analytics" \
    --resource $MH_WEBAPP_RESOURCE_ID \
    --workspace $MH_LOG_ANALYTICS_RESOURCE_ID \
    --logs '[
         {
           "category": "SystemLogs",
           "enabled": true,
           "retentionPolicy": {
             "enabled": false,
             "days": 0
           }
         },
         {
            "category": "ApplicationConsole",
            "enabled": true,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          }        
       ]' \
       --metrics '[
         {
           "category": "AllMetrics",
           "enabled": true,
           "retentionPolicy": {
             "enabled": false,
             "days": 0
           }
         }
       ]'

printf "\n\nConfiguration complete!\n"
# fin
