#!/bin/bash

FILE=/app/bin/unpub
if [ ! -f "$FILE" ]; then
    cd /app
    dart pub get
    dart compile exe bin/unpub.dart -o bin/unpub
fi

/app/bin/unpub --host $HOST --port $PORT --database $DATABASE
