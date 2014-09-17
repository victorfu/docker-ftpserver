# ftp server
#
# VERSION               0.0.1
#
# Links:
# - https://help.ubuntu.com/community/PureFTP
# - http://www.dikant.de/2009/01/22/setting-up-pureftpd-on-a-virtual-server/
# - http://download.pureftpd.org/pub/pure-ftpd/doc/README


FROM ubuntu:latest
MAINTAINER Jonas Colmsjö "jonas@gizur.com"

RUN apt-get update
RUN apt-get install -y inetutils-ftp nano wget


#
# Setup rsyslog
# ---------------------------

RUN apt-get install -y rsyslog

ADD ./etc-rsyslog.conf /etc/rsyslog.conf
ADD ./etc-rsyslog.d-50-default.conf /etc/rsyslog.d/50-default.conf


#
# Download and build pure-ftp
# ---------------------------

# RUN apt-get source pure-ftpd
# RUN tar -xzf pure-ftpd_1.0.36.orig.tar.gz 
RUN wget http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.36.tar.gz
RUN tar -xzf pure-ftpd-1.0.36.tar.gz

RUN apt-get build-dep -y pure-ftpd

RUN cd /pure-ftpd-1.0.36; ./configure optflags=--with-everything --with-privsep --without-capabilities
RUN cd /pure-ftpd-1.0.36; make; make install


#
# Configure pure-ftpd
# -------------------

RUN mkdir -p /etc/pure-ftpd/conf

RUN echo yes > /etc/pure-ftpd/conf/ChrootEveryone
RUN echo no > /etc/pure-ftpd/conf/PAMAuthentication
RUN echo yes > /etc/pure-ftpd/conf/UnixAuthentication


#
# Setup users, add as many as needed
# ----------------------------------

RUN useradd -m -s /bin/bash someone
RUN echo someone:password |chpasswd

EXPOSE 20 21
CMD ["/usr/local/sbin/pure-ftpd"]
