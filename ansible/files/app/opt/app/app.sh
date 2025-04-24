#!/bin/bash

set -euo pipefail

log_file="/var/log/app/app.log"
timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
level="INFO"
if [[ $# -eq 0 ]]; then
    echo "$timestamp|$level|App successfully started" | tee -a "$log_file"
else
    echo "$timestamp|$level|Error starting app" | tee -a "$log_file"
    exit 1
fi
