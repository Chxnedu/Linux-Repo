#!/bin/bash

# a script challenge
# this is an example of an argument. the $1 and $2 are arguments that take inputs from what you specify when you run the script
name=$1
compliment=$2
user=$(whoami)
echo "your name is $name"
sleep 1

echo "you are $compliment"
sleep 1

echo "you are logged in as $user"
