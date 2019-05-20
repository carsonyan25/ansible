#!/bin/bash
# this file used to export user defined environment variables

export EXTERNAL_IP=`curl -sS http://169.254.169.254/latest/meta-data/public-ipv4`
