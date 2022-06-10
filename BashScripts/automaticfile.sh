#!/bin/bash

# this script shows how you can implement creation and writing of files with bash

cat <<EOT >> testfile.txt
this file was automatically created
i can write scripts
obi wan kenobi is the goated jedi
star wars rules
the last of us part 1 and 2

EOT

cat testfile.txt | grep last > result.txt
