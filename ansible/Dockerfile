FROM registry.gitlab.com/registry/gitlab-ci-ansible:2.3

COPY ./requirements* /app/
WORKDIR /app

RUN apk -U add openssh \
    && pip install -r requirements.txt \
    && ansible-galaxy install -r requirements.yml 

ENTRYPOINT [ "ansible-playbook" ]

