# ftp server
#
# VERSION               0.0.1
#
# Links:
# - https://help.ubuntu.com/community/PureFTP
# - http://www.dikant.de/2009/01/22/setting-up-pureftpd-on-a-virtual-server/

FROM ubuntu:latest
MAINTAINER Jonas Colmsjö "jonas@gizur.com"

RUN apt-get update


RUN apt-get install -y inetutils-ftp
RUN apt-get build-dep -y pure-ftpd
RUN apt-get source pure-ftpd

RUN tar -xzf pure-ftpd_1.0.36.orig.tar.gz 

#RUN cd /pure-ftpd-1.0.36.orig; ./configure optflags=--with-everything --with-largefile --with-pam --with-privsep --with-tls --without-capabilities

RUN cd /pure-ftpd-1.0.36.orig; ./configure optflags=--with-everything --with-privsep --without-capabilities
RUN cd /pure-ftpd-1.0.36.orig; make; make install

#RUN dpkg-buildpackage -uc -b
#RUN dpkg -i ../pure-ftpd_1.0.1-8_i386.deb

RUN groupadd ftpgroup
RUN useradd -g ftpgroup -d /dev/null -s /etc ftpuser
RUN mkdir /home/ftpusers
RUN mkdir /home/ftpusers/joe
#RUN echo -e "password\npassword\n" > /tmp/pw
ADD ./tmp-pw /tmp/pw
RUN pure-pw useradd joe -u ftpuser -d /home/ftpusers/joe < /tmp/pw

RUN pure-pw mkdb
#RUN ln -s /etc/pure-ftpd/pureftpd.passwd /etc/pureftpd.passwd
#RUN ln -s /etc/pure-ftpd/pureftpd.pdb /etc/pureftpd.pdb
#RUN ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/PureDB
RUN chown -hR ftpuser:ftpgroup /home/ftpusers/


EXPOSE 20 21
CMD ["/usr/local/sbin/pure-ftpd"]
