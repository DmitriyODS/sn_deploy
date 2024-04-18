#!/bin/bash

echo "Transfer files to server start"

USERNAME="root"
REMOTE_SERVER="62.113.109.254"
REMOTE_PATH="/service/"

if ! command -v ssh &> /dev/null; then
    echo "Ошибка: SSH не установлен!"
    exit 1
fi

FILES_TO_COPY="db_init compose.yaml db*.sh environment.env"

for FILE in $FILES_TO_COPY; do
    scp -r $FILE $USERNAME@$REMOTE_SERVER:$REMOTE_PATH
done

echo "Transfer files to server completed"
