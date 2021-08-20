#!/usr/local/bin/python

import paramiko
import os
host = '192.168.0.31'
user = 'splunk1'
passw = 'yourpassword'

client=paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
client.connect(hostname=host, username=user, password=passw)
grepCommand="cd /home/splunk1 | ls -l"
#grepCommand="sudo find /var/log/ -type f -name '*.log' -mtime +30 -exec rm {} \;"
stdin,stdout,stderr = client.exec_command(grepCommand)
for line in stdout.readlines():
	print(line)
#print(stdout.readlines())
#data=stdout.read()
#print(data)
client.close()
