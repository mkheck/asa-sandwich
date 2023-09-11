# MH: Just a collection of commands... #!/bin/bash

# Monitoring/kill/cleanup commands

## Configure defaults so the az client can selectively ignore provided command line parameters
## Example: Creating CosmosDB MongoDB instance
## Note: Not really a great idea for community as it then overrides defaults that may be set by
## a dev's company in their env, sadly...
# az configure -d group=$MH_RESOURCE_GROUP location=$MH_REGION spring-cloud=$MH_SPRING_APPS_SERVICE subscription=$MH_SUBSCRIPTION

## Logs
### Tailing
az spring app logs -n $<app_id> -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE -f

### See more
az spring app logs -n $<app_id> -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE --lines 200

## List keys for CosmosDB account :O)
az cosmosdb keys list -n $MH_COSMOSDB_ACCOUNT -g $MH_RESOURCE_GROUP

## List all apps in this ASA instance
az spring app list -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE

## List all databases in Azure Database for MySQL "server"
az mysql db list -g $MH_RESOURCE_GROUP -s $MH_MYSQL

## App delete
az spring app delete -n $<app_id> -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE

## List resource groups for this account
az group list | jq -r '.[].name'
or
az group list --query "[].name" --output tsv

## Burn it to the ground
az group delete -g $MH_RESOURCE_GROUP 
### Apparently the sub parameter is no longer required. About time. MH 20221006 
### --subscription $MH_SUBSCRIPTION -y

## Azure Spring Apps delete, destroy, el fin de la historia
az spring delete -n $MH_SPRING_APPS_SERVICE -g $MH_RESOURCE_GROUP

## Azure Spring Apps stop (pause, deep freeze, save for later)
az spring stop -n $MH_SPRING_APPS_SERVICE -g $MH_RESOURCE_GROUP

## Create/deploy script runner, timer, logger
time <script> | tee deployoutput.txt

## Exercise endpoints

### If not already done, source envBBDFASA.sh first! Then...
export GATEWAY_URI=$(az spring app show -n $MH_GATEWAY_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE --query properties.url --output tsv)

printf "\n\nTesting deployed services at $MH_GATEWAY_URI\n"
for i in `seq 1 3`; 
do
  printf "\n\nRetrieving airports list\n"
  curl -g $MH_GATEWAY_URI/airports/

  printf "\n\nRetrieving airport\n"
  curl -g $MH_GATEWAY_URI/airports/airport/KALN

  printf "\n\nRetrieving default weather (METAR: KSTL)\n"
  curl -g $MH_GATEWAY_URI/weather

  printf "\n\nRetrieving METAR for KSUS\n"
  curl -g $MH_GATEWAY_URI/weather/metar/KSUS

  printf "\n\nRetrieving TAF for KSUS\n"
  curl -g $MH_GATEWAY_URI/weather/taf/KSUS

  printf "\n\nRetrieving current conditions greeting\n"
  curl -g $MH_GATEWAY_URI/conditions

  printf "\n\nRetrieving METARs for Class B, C, & D airports in vicinity of KSTL\n"
  curl -g $MH_GATEWAY_URI/conditions/summary
done

printf "\n\nAPI exercises complete via gateway $MH_GATEWAY_URI\n"