#!/bin/bash

# This function check if the file exist then only append the line once
function write_to_file() {
    if [ -e "$2" ]; then
        grep -qFs "$1" "$2" || echo "$1" | tee -a "$2"
    fi 
}

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export USERNAME=$(whoami)

cd $SCRIPTPATH; docker-compose up -d workspace
write_to_file  "alias workspace=\"docker exec -it --user=${USERNAME} workspace\"" ~/.bashrc
write_to_file  "alias rootspace=\"docker exec -it workspace\"" ~/.bashrc
write_to_file  "alias workspace=\"docker exec -it --user=${USERNAME} workspace\"" ~/.zshrc
write_to_file  "alias rootspace=\"docker exec -it workspace\"" ~/.zshrc
## sourcing the new changes 
. ~/.profile