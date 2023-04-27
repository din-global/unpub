FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
# RUN dart pub get

COPY . .

# RUN dart pub get --offline
# RUN dart compile exe bin/unpub.dart -o bin/unpub

FROM dart

ENV HOST 0.0.0.0
ENV PORT 4000
ENV DATABASE mongodb://host.docker.internal:27017/dart_pub
# ENV PROXY

COPY . /app/unpub

# COPY --from=build /runtime/ /
# COPY --from=build /app/bin/unpub /app/bin/
COPY --from=0 /app /app

EXPOSE 80
ADD entrypoint.sh /app
# ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
# RUN chmod +x /wait
# RUN chmod +x /app/entrypoint.sh
# ENTRYPOINT ["tail", "-f", "/dev/null"]
CMD /app/entrypoint.sh
# CMD ["sh", "-c", "/app/bin/unpub --host $HOST --port $PORT --database $DATABASE"] 
# CMD ["sh", "-c", "dart /app/bin/unpub.dart --host $HOST --port $PORT --database $DATABASE"] 
# --proxy-origin $PROXY"]
