#! /bin/bash
. ./load
Load ssh
upfile HQS_PRODUCTION www "10.0.0.2" "/data/upload/"
cmd www "10.46.68.216" "ls -l /data/upload/"
