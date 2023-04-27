#!/bin/sh
cd /app
dart pub get
dart compile exe bin/unpub.dart -o bin/unpub
/app/bin/unpub --host $HOST --port $PORT --database $DATABASE
