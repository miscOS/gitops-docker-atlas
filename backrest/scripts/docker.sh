#!/bin/bash

# This script is intended to be used as a pre-hook and post-hook for backup operations.
# It checks for containers that have the label "backup.enable=true"
# Container with "backup.mode=stop" will be stopped during backup and started again after backup.

DOCKER_LABEL_BACKUP_ENABLED="backup.enable"
DOCKER_LABEL_BACKUP_MODE="backup.mode"
DOCKER_VOLUMES_PATH="/backup/docker"

BACKUP_STOPPED_CONTAINERS_FILE="./backup-stopped-containers.tmp"
BACKUP_VOLUMES_FILE="./backup-volumes.tmp"

if [[ "$1" == "pre-hook" ]]; then

    echo "Checking containers..."
    
    # Create temporary files for storing stopped containers and volumes to be backed up.
    touch "$BACKUP_STOPPED_CONTAINERS_FILE"
    touch "$BACKUP_VOLUMES_FILE"
    
    # Loop through all containers and check for the backup labels.
    for container in $(docker ps -a -q); do

        read -r name status backup_enabled backup_mode volumes <<< $(docker inspect --format "{{ .Name }} {{ .State.Status }} {{ index .Config.Labels \"$DOCKER_LABEL_BACKUP_ENABLED\" }} {{ index .Config.Labels \"$DOCKER_LABEL_BACKUP_MODE\" }} {{ range .Mounts }}{{ .Name }} {{ end }}" "$container" | sed "s/^\/\+//")

        # If the container does not have the backup.enable label or it's not set to true, skip it.
        if [[ "$backup_enabled" != "true" ]]; then 
            continue
        fi

        echo "-----------------------------------"
        echo "Container: $name ($container)"
        echo "Status:    $status"
        echo "Mode:      $backup_mode"
        echo "Volumes:   "

        for volume in $volumes; do
            # IGNORE: NFS Volumes. They have an external backup strategy.
            type=$(docker volume inspect --format "{{ .Options.type }}" "$volume" 2>/dev/null)

            if [ "$type" = "nfs" ]; then
                continue
            fi

            # For other volumes, we will include them in the backup process.
            echo "${DOCKER_VOLUMES_PATH}/${volume}" >> "$BACKUP_VOLUMES_FILE"
            echo " - $volume"
        done

        # If the container has backup.mode=stop, we will stop it during backup and start it again after backup.
        if [ "$backup_mode" == "stop" ]; then
            echo "$name" >> "$BACKUP_STOPPED_CONTAINERS_FILE"
            docker stop "$name"
        fi

        echo "-----------------------------------"
    done

    echo "Stopped containers saved in $BACKUP_STOPPED_CONTAINERS_FILE"

elif [[ "$1" == "post-hook" ]]; then

    if [[ ! -f "$BACKUP_STOPPED_CONTAINERS_FILE" ]]; then
        echo "Stopped containers file not found. Nothing to start."
        exit 1
    fi

    echo "Starting previously stopped containers..."
    echo "-----------------------------------"

    while IFS= read -r name; do
        docker start "$name"
    done < "$BACKUP_STOPPED_CONTAINERS_FILE"

    rm -f "$BACKUP_STOPPED_CONTAINERS_FILE"
    rm -f "$BACKUP_VOLUMES_FILE"

    echo "-----------------------------------"
    echo "Done."
else
    echo "Usage: $0 {pre-hook|post-hook}"
    exit 1
fi