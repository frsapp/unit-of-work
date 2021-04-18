#!/usr/bin/env bash

docker stop $(docker ps -q --filter "name=uow")