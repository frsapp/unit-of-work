FROM node:9.11.2-alpine
RUN apk --update add curl
RUN apk --no-cache add --virtual builds-deps build-base python

LABEL authors="Ceraaj <info@ceraaj.org>"

RUN mkdir /app
WORKDIR /app

COPY ["./package.json", "tsconfig.json", "./"]
RUN npm install --registry https://npm.ceraaj.org

COPY src ./src
RUN npm -s run build

EXPOSE  80

CMD ["node", "dist"]
