#!/bin/bash

set -e

app="team8"

source './packer/functions.sh'
source './packer/params.sh'

echo creating app in $domain

exist  application ${app} && echo app ${app} already exist || create application ${appParams}
getNextVersion ${app} && deploy ${app} || create autoScaling ${autoScalingParams}
