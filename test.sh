#!/usr/bin/env bash

npm install --registry https://npm.ceraaj.org 

docker run                  \
    --rm                    \
    --name=ceraaj-service-test       \
    --env "APP_PORT=8087" \
    --env 'MONGO_DB_URL=stubbed'    \
    --env 'LOGGER_CONFIG={ "appenders": { "out": { "type": "stdout" } }, "categories": { "default": { "appenders": ["out"], "level": "error" } } } '    \
    -v "${PWD}":/app \
    -w "/app"  \
    node:9.11.2-alpine  \
    npm run test
