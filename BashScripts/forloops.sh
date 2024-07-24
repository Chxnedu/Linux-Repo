#! /bin/bash

for n in {1..10}
# the {1..10 is a way of specifying 1 through 10}
do
    echo $n
    sleep 1
done 

echo "This is outside of the for loop"
