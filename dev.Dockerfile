FROM node:9.11.2-alpine
RUN apk --update add curl
RUN apk --no-cache add --virtual builds-deps build-base python

LABEL authors="Ceraaj <info@ceraaj.org>"

RUN mkdir /app
WORKDIR /app
RUN mkdir patch

COPY ["./package.json", "tsconfig.json", "debug.sh", "./"]
EXPOSE  80

CMD ["sh", "debug.sh"]
