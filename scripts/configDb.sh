#!/bin/bash
# Author  : Mark A. Heckler
# Notes   : Run with 'source configDb.sh' AFTER envSandwichASA.sh from your shell/commandline environment
#         : OR uncomment the top 5 lines below and run this script directly (but add the values, of course)

# export MH_ROOT_NAME=<Initials or other "me"fix that is easy to remember/find in the portal>
# export MH_REGION=<your region, e.g. eastus>
# export MH_SUBSCRIPTION=<your Azure subscription>
# export MH_SPRING_APPS_SERVICE=<your ASA Enterprise instance name>
# export MH_RESOURCE_GROUP=<your resource group>

# Establish seed for random naming
export RANDOMIZER=$RANDOM
# export RANDOMIZER='6298'

export COSMOSDB_MON_ACCOUNT=$MH_ROOT_NAME'-'$RANDOMIZER'-mongoacct'
export COSMOSDB_MON_NAME=$MH_ROOT_NAME'-'$RANDOMIZER'-mongodb'

## Cosmos DB for MongoDB
az cosmosdb create -n $COSMOSDB_MON_ACCOUNT -g $MH_RESOURCE_GROUP --kind MongoDB --server-version 4.0
az cosmosdb mongodb database create -a $COSMOSDB_MON_ACCOUNT -n $MH_ROOT_NAME'-my-test-db' -g $MH_RESOURCE_GROUP --verbose

# For MongoDB API, a single URL connection string (URL+key)
# Not absolutely necessary, but useful for visual confirmation
# export COSMOSDB_MON_URL=$(az cosmosdb keys list --type connection-strings -n $COSMOSDB_MON_ACCOUNT -g $MH_RESOURCE_GROUP --query "connectionStrings[0].connectionString" --output tsv)

# Create Service Connector linking $MH_TOPPING_SERVICE_ID app with Cosmos DB
az spring connection create cosmos-mongo \
    --resource-group $MH_RESOURCE_GROUP \
    --service $MH_SPRING_APPS_SERVICE \
    --subscription $MH_SUBSCRIPTION \
    --connection Topping_Cosmongo \
    --app $MH_TOPPING_SERVICE_ID \
    --target-resource-group $MH_RESOURCE_GROUP \
    --account $COSMOSDB_MON_ACCOUNT \
    --database $MH_ROOT_NAME'-my-test-db' \
    --secret \
    --client-type springboot

# *******************************************************************************
# TO DEPLOY THE $MH_TOPPING_SERVICE_ID APP ONCE CODE CHANGES ARE MADE AND TESTED LOCALLY
# 
# 1. Rebuild the app using:
#    mvn clean package
# 2. Redeploy the updated toys app using:
#    az spring app deploy --resource-group $MH_RESOURCE_GROUP --service $MH_SPRING_APPS_SERVICE --artifact-path ./target/$MH_TOPPING_SERVICE_ID'-1.0-SNAPSHOT.jar' --name $MH_TOPPING_SERVICE_ID

# Now, go exercise those endpoints! Suggestion: hit the <gateway>/startpage a few times, refresh the app map, and chase the trace(s)!
# *******************************************************************************


# Other useful commands

## List apps
#    az spring app list -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE


## Logs
### Tailing
#    az spring app logs -n $MH_TOPPING_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE -f

### See more
#    az spring app logs -n $MH_TOPPING_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE --lines 200


## Queries
#    az spring app list -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE --query "[].name"
#    az spring app list -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE --query "[].properties.activeDeployment.properties.status"
