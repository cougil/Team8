#!/bin/bash
set -e

sudo yum clean all
sleep 1

sudo yum -y install perf nc rsyslog unzip chkconfig vim wget sysstat git
sleep 1

# Install AWS tools
sudo yum -y install aws-amitools-ec2.noarch
sleep 1
sudo yum -y install wget aws-cli.noarch
sleep 1

#Install easy_install
sudo yum install -y python-setuptools
sleep 1

#sudo easy_install pip
sudo easy_install supervisor
sleep 1

# Install 1.8 JDK
sudo yum remove -y java-1.7.0-openjdk
sudo yum install -y java-1.8.0-openjdk-devel

#For security reasons update usermode https://alas.aws.amazon.com/ALAS-2015-572.html
sudo yum update -y usermode

sudo chkconfig --add supervisord

#Create log directories
sudo mkdir /var/log/supervisord

# Start service on boot
sudo chkconfig supervisord on
sudo chkconfig --level 345 supervisord on
sleep 1


sudo chown root:root /etc/rc.d/init.d/supervisord
sudo chmod 755 /etc/rc.d/init.d/supervisord

sudo chmod 644 /etc/sysctl.conf
sudo chown root:root /etc/sysctl.conf

sudo chmod 755 /usr/local/bin/*

#Install monit
sudo yum install -y monit
sudo chkconfig monit on
sudo chkconfig --level 345 monit on

sleep 1
