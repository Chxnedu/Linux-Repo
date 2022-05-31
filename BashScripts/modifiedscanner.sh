#!/bin/bash

# improved scanner that takes input

echo "What is your IP?"
read IPaddress

echo "Which port are you looking for?"
read port

nmap -sT $IPaddress -p $port >/dev/null -oG mysqlscan2

cat mysqlscan2 | grep open > openports

cat openports
