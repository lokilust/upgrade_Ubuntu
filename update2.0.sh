#!/bin/bash

set -e

run () {
    local task=$1
    local desc=$2
    shift 2

    #local rc

    # More portable would be to use tput instead of literal escape codes
    # Avoid uppercase for non-system variables
    local red="\033[1;31m"
    local green="\033[1;32m"
    local yellow="\033[1;33m"
    local nocolor="\033[0m"

    printf "%sStep %s: %s.%s\n" "$green" "$task" "$desc" "$nocolor"
    printf "%ss%s\n" "$yellow" "$*" "$nocolor"

    if sudo "$@"; then
        printf "%sSuccess.%s\n" "$green" "$nocolor"
    else
        # The fix to capture the failed command's exit code
        # was removed by the OP in an edit of the code
        # but I'm recording it here for posterity.
        #rc=$?
        #printf "%sFailure: %s%s\n" "$red" "$task" "$nocolor"
        #return $rc
        printf "%sFailure: %s%s\n" "$red" "$task" "$nocolor"
        return "$task"
    fi
}

while IFS=: read -r exit cmd doco; do
    run $exit "$doco" "$cmd" || exit
done <<____HERE
    1:dpkg --configure -a          :configure packages
    2:apt-get install --fix-broken :fix broken dependencies
    3:apt-get update               :update cache
    4:apt-get upgrade              :upgrade packages
    5:apt-get dist-upgrade         :upgrade distribution
    6:apt-get --purge autoremove   :remove unused packages
    7:apt-get autoclean            :clean up
____HERE
