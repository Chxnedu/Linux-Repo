#! /bin/bash

# learn how to write while loops in bash

num=1

while [ $num -le 10 ]
do
    echo $num
    myvar=$(( myvar + 1 ))
    sleep 1
done
