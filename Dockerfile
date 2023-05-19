FROM google/dart:2.12 AS builder

WORKDIR /app
COPY unpub_web/pubspec.* ./
RUN dart pub get

COPY . .

WORKDIR /app/unpub_web

RUN dart pub get --offline

RUN dart pub global activate webdev 2.7.4

RUN dart pub global run webdev build

# THIS IS A WIP, IT SHOULD BUILD THE WEB FOLDER
# SO WE CAN COPY IT TO THE UNPUB FOLDER