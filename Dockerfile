FROM ubuntu:latest

ARG PASSWD=admin
ARG SSHKEY

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install  openssh-server vim sudo -y
RUN apt dist-upgrade -y

RUN update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100

RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo -u 1000 admin

RUN echo "admin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/10-admin

RUN  echo "admin:$PASSWD" | chpasswd

RUN mkdir -p /home/admin/.ssh/

RUN echo "$SSHKEY" >> /home/admin/.ssh/authorized_keys

RUN chown admin /home/admin/.ssh -R

RUN chmod 0600 /home/admin/.ssh -R

RUN chown admin /home/admin/.ssh -R

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
