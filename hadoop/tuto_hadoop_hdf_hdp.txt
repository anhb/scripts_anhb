/usr/bin/mysql_secure_installation/usr/bin/mysql_secure_installation/usr/bin/mysql_secure_installation##remover 
packagekit y actualizar sistema

systemctl stop packagekit
systemctl disable packagekit
yum -y update
yum remove -y PackageKit

##Desactivar firewall

systemctl stop firewalld
systemctl disable firewalld

##Asignar IP static

nano /etc/sysconfig/network-scripts/ifcg-

#agregar las lineas

IPADDR=192.168.1.200
NETMASK=255.255.255.0
GATEWAY=192.168.1.254
DNS=8.8.8.8

## Agregar dns

nano /etc/resolv.conf

#agregar la linea

nameserver 8.8.8.8

##Reiniciar network

systemctl restart network

##Instalar nano y ntp

yum -y install nano ntp
systemctl start ntpd
systemctl enable ntpd

##Asignar hostname

hostnamectl set-hostname master.excelerate.com --static

##agregar todos los nodos de cluster

nano /etc/hosts
192.168.1.200	master.excelerate.com	master
192.168.1.201	slave1.excelerate.com	slave1

##Editar archivo network

nano /etc/sysconfig/network

#agregar las lineas siguientes

HOSTNAME=master.excelerate.com
NETWORKING=yes

##Desactivar SELinux

setenforce 0
umask 0022
echo umask 0022 >> /etc/profile

echo -n > /etc/sysconfig/selinux
echo "# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
# 	enforcing - SELinux security policy is enforced.
# 	permissive - SELinux prints warnings instead of enforcing.
# 	disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three two values:
# 	targeted - Targeted processes are protected,
# 	minimum - Modification of targeted policy. Only selected processes are protected.
# 	mls - Multi Level Security protection.
SELINUXTYPE=targeted
" >> /etc/sysconfig/selinux

echo -n > /etc/selinux/config
echo "# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
# 	enforcing - SELinux security policy is enforced.
# 	permissive - SELinux prints warnings instead of enforcing.
# 	disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three two values:
# 	targeted - Targeted processes are protected,
# 	minimum - Modification of targeted policy. Only selected processes are protected.
# 	mls - Multi Level Security protection.
SELINUXTYPE=targeted
" >> /etc/selinux/config


systemctl restart selinux-policy-migrate-local-changes@targeted.service

##Descargar las repos del siguiente link para Centos, Si solo instalaras HDF no descargues la repo HDP y al reves
##  https://docs.hortonworks.com/HDPDocuments/HDF3/HDF-3.2.0/release-notes/content/hdf_repository_locations.html

cd /etc/yum.repos.d/

# HDF 3.2.0

wget http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.2.0.0/hdf.repo

# Ambari 

wget http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.7.0.0/ambari.repo

# HDP 3.0.0

wget http://public-repo-1.hortonworks.com/HDP/centos7/3.x/updates/3.0.0.0/hdp.repo


##Actualizar repositorios instalados

yum repolist

## Instalar ambari server y agent (Solo en el nodo master, en nodos slaves solo es ambari-agent)

yum -y install ambari-server ambari-agent
yum -y install ambari-agent

## Instalar mysql y configurar en ambari-server (Solo nodo master)

yum -y install mysql-connector-java*
ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar
yum -y localinstall https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
yum -y install mysql-community-server
systemctl start mysqld.service
systemctl enable mysqld.service

## Buscar contraseña temporal mysql y debes copiar la contraseña que aparezca

grep 'A temporary password is generated for root@localhost' /var/log/mysqld.log |tail -1

##Cambiar contraseña mysql

/usr/bin/mysql_secure_installation

#Contraseña nueva

3xcE1erate1*

## Te preguntara una serie de pasos
#1- contraseña por default
#2- contraseña para root
#3- remover usuarios anonimos (enter para skip)
#4- Deshabilitar inicio de sesion remotamente (enter para skip)
#5- Remover base de datos llamada test (enter para skip)
#6- recargar privilegios de tablas (enter para skip)


## Configurar servicios de HDF en mysql

mysql -u root -p

#Configurar root

CREATE USER 'root'@'%' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'root'@'master.excelerate.com' IDENTIFIED BY '3xcE1erate1*';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'master.excelerate.com' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION ;



#Configurar sam y schema registry metadata stores en mysql

create database registry;
create database streamline;
CREATE USER 'registry'@'%' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'streamline'@'%' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'registry'@'master.excelerate.com' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'streamline'@'master.excelerate.com' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'registry'@'localhost' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'streamline'@'localhost' IDENTIFIED BY '3xcE1erate1*';
GRANT ALL PRIVILEGES ON registry.* TO 'registry'@'localhost' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON streamline.* TO 'streamline'@'localhost' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON registry.* TO 'registry'@'master.excelerate.com' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON streamline.* TO 'streamline'@'master.excelerate.com' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON registry.* TO 'registry'@'%' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON streamline.* TO 'streamline'@'%' WITH GRANT OPTION ;
commit;

#Configurar Druid y superset metadata stores en mysql

CREATE DATABASE druid DEFAULT CHARACTER SET utf8;
CREATE DATABASE superset DEFAULT CHARACTER SET utf8;
CREATE USER 'druid'@'%' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'superset'@'%' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'druid'@'master.excelerate.com' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'superset'@'master.excelerate.com' IDENTIFIED BY '3xcE1erate1*';
GRANT ALL PRIVILEGES ON *.* TO 'druid'@'master.excelerate.com' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'superset'@'master.excelerate.com' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'druid'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'superset'@'%' WITH GRANT OPTION;
commit;

#Create ambari user

uninstall plugin validate_password;
CREATE USER 'ambari'@'master.excelerate.com' IDENTIFIED BY 'bigdata';
CREATE USER 'ambari'@'%' IDENTIFIED BY 'bigdata';
GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'master.excelerate.com' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'%' WITH GRANT OPTION;
commit;

#Te sales y entras con el usuario ambari

mysql -u ambari -p
CREATE DATABASE ambari;
USE ambari;
SOURCE /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql

#Si sale error de column data hacer lo siguiente

ALTER TABLE hosts MODIFY public_host_name longtext;
exit
ambari-server restart

##Crear usuario Ranger

CREATE USER 'rangeradmin'@'master.excelerate.com' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'rangeradmin'@'%' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'rangerkms'@'master.excelerate.com' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'rangerkms'@'%' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'rangerdba'@'master.excelerate.com' IDENTIFIED BY '3xcE1erate1*';
CREATE USER 'rangerdba'@'%' IDENTIFIED BY '3xcE1erate1*';

GRANT ALL PRIVILEGES ON *.* TO 'rangeradmin'@'master.excelerate.com' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'rangeradmin'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'rangerkms'@'master.excelerate.com' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'rangerkms'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'rangerdba'@'master.excelerate.com' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'rangerdba'@'%' WITH GRANT OPTION;
commit;



## Instalar MPack, este sirve para que HDF funcione en ambari, no lo instales si lo haces sobre un cluster HDP instalado
## Si instalas HDP + HDF o solamente HDF realizar el siguiente paso. Si solo es HDP no debes seguir este paso. 
#Hacer backup del directorio de recursos de ambari

cp -r /var/lib/ambari-server/resources /var/lib/ambari-server/resources.backup
cd /tmp
wget http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.2.0.0/tars/hdf_ambari_mp/hdf-ambari-mpack-3.2.0.0-520.tar.gz
ambari-server install-mpack --mpack=/tmp/hdf-ambari-mpack-3.2.0.0-520.tar.gz --purge --verbose

## Configura todos los ambari-agent con el hostname master
#Edita en la seccion [server] la linea "hostname", quita localhost por fqdn master

nano /etc/ambari-agent/conf/ambari-agent.ini

##Reinicia la maquina para que no salga el warning de SELinux

reboot

## Configura Ambari-server

ambari-server setup

#Te preguntara algunos pasos
#1- Modificar cuenta usuario de ambari-server (dar enter "no por default")
#2- Instalar JDK 1.8 darle en la opcion 1, si es diferente tu caso, seleccionarlo, y aceptar la licencia.
#3- Habilitar GPL LZO license que es una funcion para poder hacer compresion de datos en ese formato, sirve para Hive (por default darle no)
#4- Ingresar a avanzada configuracion de bases de datos (Por default no)


## Ahora en el nodo master inicias tanto ambari-server como ambari-agent, en nodos slave unicamente ambari-agent

ambari-agent start
ambari-server start


## Ahora ingresar a ambari desde un navegador  "ip:8080"
#Los siguientes pasos es por medio de esta interfaz

#1- Ingresar nombre cluster

ExcelerateSystems

#2- Deberias ver los repositorios HDF Y HDP

quitar todos las repos que sean diferentes a tu sistema operativo
dar next

#3- Agregar Hostnames

master.excelerate.com
slave1.excelerate.com

y dar click en la opcion "perform manual registration on hosts and don't use SSH"
como se instalaron los agentes, no necesitas ssh

#4- Esperar a que todo este bien

Si algo sale mal, puedes ejectuar el siguiente comando en los nodos para ver los logs

tail -fn 200 /var/log/ambari-agent/ambari-agent.log

#5- Seleccionas todos los servicios que se instalaran

este paso es a tus preferencias

#6- Distribuye los servicios entre los nodos

igual este paso a tu preferencia

#7- Asignar slaves y clientes

iguales este paso por lo regular seleccionas en todos a todos
excepto tangertagsync

#8- Configurar credenciales

asignar las que gustes, pero cuidado con los de las bases de datos
en mi caso pondre la misma

3xcE1erate1*

#9- configurar bases de datos

Ranger te da la opcion de hacer test de conexion, como solo se realizo los usuarios
necesitas apuntar a localhost, si no quieres, debes crear los usuarios con el host
correspondiente

#10- Directorios


##Eliminar base de datos ambari por error

##Opcional
yum clean all
yum repolist
su - postgres
psql
\l
DROP DATABASE ambari;
\q
exit
ambari-server setup




ambari configurations nifi

advanced nifi-state-management-env



            <!--
            Licensed to the Apache Software Foundation (ASF) under one or more
            contributor license agreements.  See the NOTICE file distributed with
            this work for additional information regarding copyright ownership.
            The ASF licenses this file to You under the Apache License, Version 2.0
            (the "License"); you may not use this file except in compliance with
            the License.  You may obtain a copy of the License at
            http://www.apache.org/licenses/LICENSE-2.0
            Unless required by applicable law or agreed to in writing, software
            distributed under the License is distributed on an "AS IS" BASIS,
            WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
            See the License for the specific language governing permissions and
            limitations under the License.
            -->

            <!--
            This file provides a mechanism for defining and configuring the State Providers
            that should be used for storing state locally and across a NiFi cluster. In order
            to use a specific provider, it must be configured here and its identifier
            must be specified in the nifi.properties file.
            -->
            <stateManagement>
            <!--
            State Provider that stores state locally in a configurable directory. This Provider requires the following properties:

            Directory - the directory to store components' state in. If the directory being used is a sub-directory of the NiFi installation, it
            is important that the directory be copied over to the new version when upgrading NiFi.
            -->
            <local-provider>
            <id>local-provider</id>
            <class>org.apache.nifi.controller.state.providers.local.WriteAheadLocalStateProvider</class>
            <property name="Directory">{{nifi_state_dir}}</property>
            <property name="Always Sync">false</property>
            <property name="Partitions">16</property>
            <property name="Checkpoint Interval">2 mins</property>
            </local-provider>

            <!--
            State Provider that is used to store state in ZooKeeper. This Provider requires the following properties:

            Root Node - the root node in ZooKeeper where state should be stored. The default is '/nifi', but it is advisable to change this to a different value if not using
            the embedded ZooKeeper server and if multiple NiFi instances may all be using the same ZooKeeper Server.

            Connect String - A comma-separated list of host:port pairs to connect to ZooKeeper. For example, myhost.mydomain:2181,host2.mydomain:5555,host3:6666

            Session Timeout - Specifies how long this instance of NiFi is allowed to be disconnected from ZooKeeper before creating a new ZooKeeper Session. Default value is "30 seconds"

            Access Control - Specifies which Access Controls will be applied to the ZooKeeper ZNodes that are created by this State Provider. This value must be set to one of:
            - Open  : ZNodes will be open to any ZooKeeper client.
            - CreatorOnly  : ZNodes will be accessible only by the creator. The creator will have full access to create children, read, write, delete, and administer the ZNodes.
            This option is available only if access to ZooKeeper is secured via Kerberos or if a Username and Password are set.
            -->


            <cluster-provider>
            <id>zk-provider</id>
            <class>org.apache.nifi.controller.state.providers.zookeeper.ZooKeeperStateProvider</class>
            <property name="Connect String">{{zookeeper_quorum}}</property>
            <property name="Root Node">{{nifi_znode}}</property>
            <property name="Session Timeout">30 seconds</property>
            <property name="Access Control">Open</property>
            </cluster-provider>
            </stateManagement>
