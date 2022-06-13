#!/bin/bash

# a script to automate the creation of my mongo containers



docker run -d -p 27017:27017 --name mongodb --network mongo-network -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password mongo

sleep 10

docker run -d -p 8081:8081 --name mongoexpress --network mongo-network -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin -e ME_CONFIG_MONGODB_ADMINPASSWORD=password -e ME_CONFIG_MONGODB_SERVER=mongodb mongo-express

docker ps
