#!/bin/bash

set -euo pipefail

log_file="/var/log/app/app.log"

if [[ $# -eq 0 ]]; then
    echo "App successfully started" | tee -a "$log_file"
else
    echo "Error starting app" | tee -a "$log_file"
    exit 1
fi
