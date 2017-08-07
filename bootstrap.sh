#!/bin/bash

#set -x

BAMBOO_DATA=$1

#echo $BAMBOO_HOME
#echo $BAMBOO_INSTALL

#/home/rvaldes/Contenedores/docker-atlassian-bamboo


docker run --detach --publish 8085:8085 --name cybersyn-ci -v $BAMBOO_DATA/data/bamboo-home:/var/atlassian/bamboo -v $BAMBOO_DATA/data/bamboo-install:/opt/atlassian/bamboo -v $BAMBOO_DATA/data/maven-repo:/usr/sbin/.m2/repository cybersyn/bamboo

#/home/rvaldes/Contenedores/docker-atlassian-bamboo/data/bamboo-install/bamboo

#docker run --detach --publish 8085:8085 --name cybersyn-ci 


#ENV BAMBOO_HOME     /var/atlassian/bamboo
#ENV BAMBOO_INSTALL  /opt/atlassian/bamboo

