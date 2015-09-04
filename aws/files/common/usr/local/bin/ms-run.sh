#!/bin/bash

eval $(/usr/local/bin/userdata)
JAVA_ARGS=$(/usr/local/bin/setEnv.sh)

$1 $2 "$JAVA_ARGS"
