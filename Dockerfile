FROM node:lts-alpine

ARG production

EXPOSE 8080

LABEL maintainer="bafolts" \
      name="terraforming-mars" \
      Version="1.0"

RUN mkdir -p /usr/src/app/db \
   && addgroup -S tfm \
   && adduser -S -D -h /usr/src/app tfm tfm \
   && apk add --no-cache git

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN chown -R tfm:tfm /usr/src/app
RUN if [[ -n "$production" ]] ; then npm run build:production ; else npm run build ; fi
RUN rm -rf .git \
   && apk del git

USER tfm

CMD [ "npm", "run", "start" ]
