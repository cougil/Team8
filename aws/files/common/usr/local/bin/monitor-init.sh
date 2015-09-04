#!/bin/bash

eval $(/usr/local/bin/userdata)
if [ "$CLOUD_ENVIRONMENT" = "ms" ]; then
  service datadog-agent start
fi
