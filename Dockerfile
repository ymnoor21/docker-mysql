FROM ubuntu:14.04.4
MAINTAINER Yamin Noor <ymnoor21@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive

# Download wget, mysql 5.7 deb package and install dpkg
RUN \
  apt-get -y update && apt-get install -y wget \
  && wget http://repo.mysql.com/mysql-apt-config_0.7.3-1_all.deb \
  && mv mysql-apt-config_0.7.3-1_all.deb /home \
  && cd /home \
  && apt-get install -y dpkg-dev \
  && apt-get -y update

# install mysql 5.7 deb package using dpkg
RUN dpkg -i /home/mysql-apt-config_0.7.3-1_all.deb
RUN apt-get -y update

# install mysql
RUN apt-get install -y mysql-server

# edit mysql configuration
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
RUN sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf
  
# Define default command.
CMD ["mysqld_safe"]

# add shell script and run some database commands
ADD init-db.sh /home/init-db.sh
ADD dump/sample.sql /home/sample.sql
RUN chmod +x /home/init-db.sh \
    && /home/init-db.sh

# Expose ports.
EXPOSE 3306
