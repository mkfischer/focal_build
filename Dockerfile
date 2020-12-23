FROM ubuntu:latest

ARG PASSWD=admin

RUN apt update && apt install  openssh-server sudo -y
RUN apt dist-upgrade -y

RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo -u 1000 admin

RUN  echo "admin:$PASSWD" | chpasswd

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
