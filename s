#!/bin/sh

DAY="$1"
LEVEL="${2:-1}"
bzn -y 2017 -d $DAY | julia "day$1.jl" $LEVEL | bzn -y 2017 -d $DAY submit -l $LEVEL
