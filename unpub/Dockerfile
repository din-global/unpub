FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub get --offline
RUN dart compile exe bin/unpub.dart -o bin/unpub

FROM dart:stable

ENV HOST 0.0.0.0
ENV PORT 4000
ENV DATABASE mongodb://host.docker.internal:27017/dart_pub

COPY --from=build /runtime/ /
COPY --from=build /app/bin/unpub /unpub
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

CMD /wait && /unpub --host $HOST --port $PORT --database $DATABASE
# CMD ["sh", "-c", "/unpub --host $HOST --port $PORT --database $DATABASE"] 
