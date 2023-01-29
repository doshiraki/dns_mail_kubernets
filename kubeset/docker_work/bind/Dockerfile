FROM ubuntu/bind9:edge
SHELL [ "/bin/bash", "-c" ]
USER root
RUN apt-get update && apt-get install -y python3.10-venv
#RUN apt-get update && apt-get install -y vim sshpass openssh-server python3.10-venv
RUN python3.10 -m venv /root/py3 && \
    . /root/py3/bin/activate ; \
    python -m pip install --upgrade pip && \
    pip install ansible
#RUN useradd -m ansible -d /mnt/ansible/ansroot
COPY ./ansroot /root/ansroot
WORKDIR /root/ansroot

RUN source ../py3/bin/activate ; ansible-playbook -i inventory/std/host.yaml playbooks/dns-server.yml
