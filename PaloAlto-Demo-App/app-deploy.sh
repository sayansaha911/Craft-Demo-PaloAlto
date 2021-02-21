#!/bin/bash
#buld the sample http app with go build

read -p "enter app-name (example:sayansaha911/demo-app )= " app_name
#read -p "enter app-version (example:0.1.2 )= " app_version

echo "Building binary" && \
cd app-code/ && \
GOOS=linux GOARCH=amd64 go build -tags netgo -o http-sample && \
cd .. && \

echo "building docker image" && \
docker build -t ${app_name}:latest . && \

echo "pushing docker image" && \
docker push ${app_name}:latest && \


if [[ $(helm list --output json | jq -r .[] | jq -r ".name") = demo-app ]]
then

echo "Upgrading web-app"
helm upgrade demo-app ./helm-chart/ --set image.repository=${app_name}
else

echo "Installing web-app"
helm install demo-app ./helm-chart/ --set image.repository=${app_name}
fi
