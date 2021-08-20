# Actualizar los paquetes del sistema

yum -y update

# Instalar los paquetes de nfs y openssh

yum install -y nfs-utils nfs-utils-lib openssh*

# Configurar IP's staticas

vi /etc/sysconfig/network-scripts/ifcfg-eno2
vi /etc/sysconfig/network-scripts/enp2s0f0

### Agregar:
## IPADDR=ip_statica
## GATEWAY=puerta_enlace
## DNS=dns_
## NETMASK=mascara_subred

###Cambiar:
## BOOTPROTO=none
## ONBOOT=yes

# Iniciar los servicios de nfs

chkconfig nfs on
service rpcbind start
service nfs start

# Agregar los servicios nfs al firewall

firewall-cmd --permanent --zone=public --add-service=nfs
firewall-cmd --permanent --zone=public --add-service=mountd
firewall-cmd --permanent --zone=public --add-service=rpc-bind

# Reiniciar firewall

firewall-cmd --reload

# Crear directorio nfs para poder compartir y cambiar sus permisos

mkdir /var/nas-ine
chmod 767 /var/nas-ine

# Ver los dispositivos conectados de almanecamiento

lsblk

# Crear una particion lvm con la herramienta fdisk

fdisk /dev/sdb

# Opciones
#	n
#	p
#	1
#	enter
#	p
#	t
#	1
#	L
#	8e	LINUX LVM
#	p
#	w

# Iniciarlizar particion lvm como un volumen fisico

pvcreate /dev/sdb1

# Ver los dispositivos en blocks

lvmdiskscan

# Crear un grupo de volumenes, se llamara "nasine" y agregar la particion

vgcreate nasine /dev/sdb1

# Crear un volumen logico

lvcreate nasine -L 930GB -n part1

# Ver los volumenes logicos creados

lvdisplay

# Una vez teniendo eso vemos el punto de montaje

ls -l /dev/nasine/part1 

# Se asigna el formato ext4 a la particion LVM con nuestro punto de montaje

mkfs.ext4 /dev/dm-0

# Ahora solo es necesario iniciar el montaje automaticamente desde fstab

nano /etc/fstab

# Se agrega la siguiente linea:
# /dev/dm-0	/var/nas-ine    ext4    defaults,auto   0 2

# Si deseas montar en el momento el punto de montaje

mount -t ext4 /dev/dm-0 /var/nas-ine/

# Agregar IP's de los clientes que tendran acceso al directorio nfs-ine

vi /etc/exports

# /var/nas-ine    10.1.5.53/255.255.255.0(rw,sync,no_subtree_check,no_root_squash)
# /var/nas-ine    10.1.5.51/255.255.255.0(rw,sync,no_subtree_check,no_root_squash)
# /var/nas-ine    10.1.5.52/255.255.255.0(rw,sync,no_subtree_check,no_root_squash)

# Una vez configurado el archivo se necesita el siguiente comando para poder exportar cada directorio

exportfs -a

# Se reinician los servicios de nfs

service nfs restart
