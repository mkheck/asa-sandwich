#!/bin/bash

# Author  : Mark Heckler
# Notes   : Must have sourced envSandwichASA.sh and run configSandwichASA.sh before
#           this script per previous instructions
# History : Official "version 1" 20230911.
#         : 

clear
printf "\nDeploying app artifacts to Spring Apps\n"

# Deploy the actual applications
printf "\n\nDeploying $MH_GATEWAY_SERVICE_ID\n"
az spring app deploy -n $MH_GATEWAY_SERVICE_ID \
    -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
    --artifact-path $MH_GATEWAY_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

printf "\n\nDeploying $MH_STARCH_SERVICE_ID\n"
az spring app deploy -n $MH_STARCH_SERVICE_ID \
    -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
    --artifact-path $MH_STARCH_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

printf "\n\nDeploying $MH_TOPPING_SERVICE_ID\n"
az spring app deploy -n $MH_TOPPING_SERVICE_ID \
    -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
    --artifact-path $MH_TOPPING_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

printf "\n\nDeploying $MH_FOOD_SERVICE_ID\n"
az spring app deploy -n $MH_FOOD_SERVICE_ID \
    -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE \
    --artifact-path $MH_FOOD_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

# Exercise those endpoints
export GATEWAY_URI=$(az spring app show -n $MH_GATEWAY_SERVICE_ID -g $MH_RESOURCE_GROUP -s $MH_SPRING_APPS_SERVICE --query properties.url --output tsv)

printf "\n\nTesting deployed services at $MH_GATEWAY_URI\n"
for i in `seq 1 3`; 
do
#   printf "\n\nRetrieving default value via airport app: testplane\n"
#   curl -g $MH_GATEWAY_URI/airports/testplane
#   printf "\n\nRetrieving default value via airport app: testcomplexplane\n"
#   curl -g $MH_GATEWAY_URI/airports/testcomplexplane
#   printf "\n\nRetrieving default value via airport app: testairport\n"
#   curl -g $MH_GATEWAY_URI/airports/testairport
#   printf "\n\nRetrieving default value via airport app: testfuel\n"
#   curl -g $MH_GATEWAY_URI/airports/testfuel

  printf "\n\nRetrieving airports list\n"
  curl -g $MH_GATEWAY_URI/airport/

  printf "\n\nRetrieving airport\n"
  curl -g $MH_GATEWAY_URI/airport/airport/KALN

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
