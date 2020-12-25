#!/bin/bash

echo $1
echo $2
gemBS prepare -c $1 -t $2
gemBS index
gemBS map
gemBS call
gemBS extract
gemBS map-report
gemBS call-report
