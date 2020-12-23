FROM ubuntu:latest

ARG PASSWD=admin
ARG SSHKEY

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install  openssh-server sudo -y
RUN apt dist-upgrade -y

RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo -u 1000 admin

RUN  echo "admin:$PASSWD" | chpasswd

RUN mkdir -p /home/admin/.ssh

RUN echo "$SSHKEY" > /home/admin.ssh/authorized_keys
RUN sed -ri '/\#\s?PermitRootLogin prohibit-password\s?/Id' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin yes\s?/PermitRootLogin prohibit-password/gI' /etc/ssh/sshd_config
RUN sed -ri 's/PasswordAuthentication yes\s?/PasswordAuthentication no/gI' /etc/ssh/sshd_config
RUN sed -ri 's/#PasswordAuthentication yes\s?/PasswordAuthentication no/gI' /etc/ssh/sshd_config

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
