FROM ubuntu:lunar
SHELL [ "/bin/bash", "-c" ]
USER root
RUN apt-get update && apt-get install -y python3-pip python3.10-venv
RUN pip install cryptography
RUN python3.10 -m venv /root/py3 && \
    . /root/py3/bin/activate ; \
    python -m pip install --upgrade pip && \
    pip install ansible
RUN apt-get install -y locales && \
    localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y postfix postfix-pcre dovecot-imapd

WORKDIR /root
COPY ./requirements.yml /root
RUN source /root/py3/bin/activate ; \
    ansible-galaxy collection install -r requirements.yml

WORKDIR /root/ansroot
COPY ./ansroot /root/ansroot

RUN source /root/py3/bin/activate ; \
    ansible-playbook -i inventory/std/host.yaml playbooks/mail-server.yml

CMD service postfix start && \
    service dovecot start && \
     tail -f /var/log/postfix/postfix.log
