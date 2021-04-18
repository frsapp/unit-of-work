#!/usr/bin/env bash

npm install --registry https://npm.ceraaj.org

echo "Checking for network..."
docker network ls | grep "oryx" >/dev/null
if [[ ! $? -eq 0 ]]
then
    echo "Installing network for oryx containers..."
    docker network create oryx
fi

docker build . -f dev.Dockerfile -t oryx-uow:local
docker stop $(docker ps -q --filter "name=uow")
docker run -d --rm                                          \
    --name=oryx-uow-mongodb                  \
    --network=oryx                                         \
    -p 25017:27017                                          \
    -v oryx-uow-mongodb-volume:/data/db      \
    mvertes/alpine-mongo

docker run                  \
    --rm                    \
    --name=uow       \
    --env "APP_PORT=80"     \
    --env 'MONGO_DB_URL=mongodb://oryx-uow-mongodb:27017/uowDb'    \
    --env 'LOGGER_CONFIG={"appenders":{"out":{"type":"stdout","layout":{"type":"pattern","pattern":"%[[%d] [%p] %c - %G{correlationId}%] - %m%n"}}},"categories":{"default":{"appenders":["out"],"level":"trace"}}}'    \
    --network=oryx         \
    -v ${PWD}:/app \
    -v oryx-uow_node_modules:/app/node_modules       \
    -w "/app"              \
    -p 8000:80              \
    oryx-uow:local
