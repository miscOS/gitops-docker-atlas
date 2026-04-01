#!/bin/bash

TMP_FILE="./stopped-containers.tmp"

touch "$TMP_FILE"

if [[ ! -f "$TMP_FILE" ]]; then
    echo "Error: failed to create temporary file: $TMP_FILE"
    exit 1
fi

if [[ "$1" == "stop" ]]; then
    echo "Stopping containers..."
    
    for id in $(docker ps -q); do
        KEEP=$(docker inspect -f '{{ index .Config.Labels "backrest.keep-alive" }}' "$id" 2>/dev/null)
        if [[ "$KEEP" != "true" ]]; then
            NAME=$(docker inspect -f '{{ .Name }}' "$id" | sed 's/^\/\?//')
            echo "$NAME" >> "$TMP_FILE"
            docker stop "$NAME"
        fi
    done

    echo "Stopped containers saved in $TMP_FILE"

elif [[ "$1" == "start" ]]; then
    if [[ ! -f "$TMP_FILE" ]]; then
        echo "No temporary file found. Nothing to start."
        exit 1
    fi

    echo "Starting previously stopped containers..."
    while IFS= read -r name; do
        docker start "$name"
    done < "$TMP_FILE"

    rm -f "$TMP_FILE"

    echo "Done."
else
    echo "Usage: $0 {stop|start}"
    exit 1
fi