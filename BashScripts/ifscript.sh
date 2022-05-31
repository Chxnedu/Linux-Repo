#!/bin/bash

# a script using the if statement

echo "what is your name?"
read name

# always remember to put the double quotations for each variable
# if not your code won't work
# and always space your work

if [ "$name" = "chxnedu" ]
then
       echo "welcome $name, you're not a hacker"

# the elif statement checks for another variable

elif [ "$name" = "chinedu" ]
   then 
echo "welcome $name, I recognize you too"

else
     sleep 1
       echo "getat!!, you wan hack"

# fi to end the if statement
fi 

# COMPARISONS
# -eq returns true if the values are equal
# -ne returns true if the values are not equal
# -gt returns true if val1 is greater than val2
# -lt returns true if val1 is less than val2
# -le returns true if val1 is less than or equal to val2

