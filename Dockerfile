FROM alpine:3.10

ENV TERRAFORM_VERSION 0.12.23

RUN apk add --update wget ca-certificates unzip git bash && \
    wget -q -O /terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip /terraform.zip -d /bin && \
    apk del --purge wget ca-certificates unzip && \
    rm -rf /var/cache/apk/* /terraform.zip

RUN apk add jq
RUN apk add openssh-client
RUN apk add openssl-dev
RUN apk add ansible
RUN apk add curl

COPY . /app

ENV PLAYBOOK_DIR /app/

WORKDIR /app
CMD ./docker-deploy
