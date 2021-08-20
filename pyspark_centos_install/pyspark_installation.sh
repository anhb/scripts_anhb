## If you have internet you can use next links to downlodad dependencies
## These packages already exist in the unzip
## Not use these wget in your case continue in the Java Installation

wget -c https://downloads.apache.org/spark/spark-2.4.7/spark-2.4.7-bin-hadoop2.7.tgz
wget -c https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz

###JAVA INSTALLATION
### Link Reference: https://www.javahelps.com/2015/03/install-oracle-jdk-in-ubuntu.html
### Link2 Reference: https://www.vultr.com/docs/how-to-manually-install-java-8-on-ubuntu-16-04
### JDK download: https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html

mkdir /usr/lib/jvm
tar -zxvf jdk-8u271-linux-x64.tar.gz -C /usr/lib/jvm/
vi /etc/environment

## Add the following content to the environment file (copy-paste)
--------------------------------------------------------
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/jdk1.8.0_271/bin:/usr/lib/jvm/jdk1.8.0_271/db/bin:/usr/lib/jvm/jdk1.8.0_271/jre/bin"
J2SDKDIR="/usr/lib/jvm/jdk1.8.0_271"
J2REDIR="/usr/lib/jvm/jdk1.8.0_271/jre"
JAVA_HOME="/usr/lib/jvm/jdk1.8.0_271"
DERBY_HOME="/usr/lib/jvm/jdk1.8.0_271/db"
-------------------------------------------------------

## execute these commands for java installing

update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_271/bin/java" 0
update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_271/bin/javac" 0
update-alternatives --set java /usr/lib/jvm/jdk1.8.0_271/bin/java
update-alternatives --set javac /usr/lib/jvm/jdk1.8.0_271/bin/javac

#### Optional Step to verify java installation
----------------------------------
update-alternatives --list java
update-alternatives --list javac
java -version
----------------------------------

###SPARK INSTALLATION
tar -zxvf spark-2.4.7-bin-hadoop2.7.tgz -C /opt/

## Only extracting tgz the spark is installed, you could execute the spark-shell using next sentence
### SPARK SHELL EXECUTION

/opt/spark-2.4.7-bin-hadoop2.7/bin/./spark-shell

###PYSPARK INSTALLATION
##For PySpark you need to install Python 3.7
##Link Reference: https://medium.com/@CurtisForrester/installing-python3-in-centos-7-6-offline-69d45ca48054
##Link Reference2: https://www.liquidweb.com/kb/how-to-install-python-3-on-centos-7/


tar -zxvf Python-3.7.9.tgz -C /opt/

##But to execute python we need to install python dependencies first

cd /home/user/python_dependencies_centos/
rpm -Uvh ./*.rpm --nodeps --force

##If you can execute now python, I prefer not follow next steps, only symbolic link
##Once time installed we have to configure python
-------------------------------------------------
/opt/Python-3.7.9/./configure --enable-optimizations && make
make altinstall
python3.7
exit
ln -s /usr/local/bin/python3.7 /usr/bin/python   # Create a python 3 soft connection
ln -s /usr/local/bin/pip3.7 /usr/bin/pip # Create a soft connection for pip3
/opt/spark-2.4.7-bin-hadoop2.7/bin/./pyspark
-----------------------------------------------

###Execute Scripts for Python
/opt/spark-2.4.7-bin-hadoop2.7/bin/./spark-submit file.py

#Example code using PySpark

textFile = sc.textFile("/home/user/text_example_for_spark") //Read Text File
textFile.first() //Print first line of the file
textFile.count() //Count lines in the file
exit() //exit spark shell

#Example code using spark scala

val textFile = spark.read.textFile("/home/user/text_example_for_spark") //Read Text File
textFile.first() //Print first line of the file
textFile.count() //Count lines in the file
:quit //exit spark shell


### Extra information
## You can download packages manually in the following link:
http://mirror.centos.org/

## to download rpm packages from repository in a computer with network connection you could use following command

yum install --downloadonly --downloaddir=/home/user/python_dependencies_centos/ zlib-devel bzip2-devel openssl-devel ncurses-devel  epel-release gcc gcc-c++ xz-devel readline-devel gdbm-devel sqlite-devel tk-devel libffi-devel make libffi wget yum
