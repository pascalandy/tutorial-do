FROM python:2-alpine

COPY ./requirements* /app/
WORKDIR /app

RUN apk update && apk upgrade \
    apk -U add make openssh gcc libc-dev libffi-dev openssl-dev ca-certificates git sshpass \
    && pip install -r requirements.txt \
    && ansible-galaxy install -r requirements.yml 

ENTRYPOINT [ "ansible-playbook" ]

