#!/usr/bin/env bash

set -e

export creator=$(git --no-pager show -s --format='%ae' ${TRAVIS_COMMIT})
export creation_time=`date +"%Y%m%d%H%M%S"` 
export appversion="0.0.${TRAVIS_BUILD_ID}" 
export ec2_source_ami=ami-a10897d6
packer -machine-readable build packer/build.json | tee output.txt