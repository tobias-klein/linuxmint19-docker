# Dockerfile for Linux Mint 19.3 Build Enviroment for Ezra Project

FROM vcatechnology/linux-mint

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN apt-get -y install apt-utils
RUN apt-get -y update

# Upgrade from Sonya (18.2) to Sylvia (18.3)
RUN sed -i 's/sonya/sylvia/g' /etc/apt/sources.list.d/mint.list
RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y install mintupgrade python3-apt
RUN apt-get -y install cron psmisc
RUN apt-get -y install timeshift
RUN touch /etc/timeshift.json

RUN useradd -ms /bin/bash upgrade
RUN usermod -p $(echo upgrade | openssl passwd -1 -stdin) upgrade

# Give the upgrade user all permissions
RUN echo "upgrade ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV TERM=xterm
RUN sed -i 's/answer = None/answer = "y"/g' /usr/bin/mintupgrade
RUN runuser -l upgrade -c 'mintupgrade download'
RUN runuser -l upgrade -c 'mintupgrade upgrade'
RUN deluser --remove-home upgrade

