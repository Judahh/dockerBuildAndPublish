ARG  NODE_VERSION=latest
FROM node:${NODE_VERSION}

ARG PROJECT_URL=https://alpha-ci-deploy.s3.us-east-2.amazonaws.com/
ARG SERVICE_NAME=AUTH
ARG PROJECT_ENV=production

ENV PROJECT_URL=$PROJECT_URL
ENV SERVICE_NAME=$SERVICE_NAME
ENV PROJECT_ENV=$PROJECT_ENV

# Create app directory
WORKDIR /usr/src/api
RUN chown -R node /usr/src/api && \
    chmod +x -R /usr/src/api && \
    chmod 777 -R /usr/src/api

COPY docker/*updater.sh ./
COPY *node_modules ./node_modules
COPY *.next ./.next
COPY *public ./public
COPY *dist ./dist
COPY *package.json ./

RUN chmod +x updater.sh
RUN apt-get update -y && \
    apt-get install software-properties-common gcc -y
    # && \
    # apt-get update -y && \
    # apt-get -y install python3 python3-pip cron musl-dev unzip && \
    # alias pip=pip3 && \
    # update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 && \
    # pip install --upgrade pip && \
    # pip install xmltodict requests datetime wget
RUN ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1

RUN chmod 777 -R ../api && \
    chmod +x -R ../api

USER node

# RUN chmod +x -R ../api

EXPOSE 3000

CMD ["sh", "updater.sh"]
