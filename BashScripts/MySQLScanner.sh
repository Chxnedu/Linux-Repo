#! /bin/bash

# a script to find hosts with mysql installed

nmap -sT 10.0.2.15/24 -p 3306 >/dev/null -oG MySQLscan

cat MySQLscan | grep open > MySQLscan2

cat MySQLscan2
