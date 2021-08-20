### Creating keys to master node
# Create private key and certificate
openssl req -x509 -newkey rsa:2048 -keyout admin-private-key.pem -out admin-cert.pem -days 365 -subj "/CN=Nifi admin/C=MX/L=MexicoCity" -nodes

# Create a pair of keys
openssl pkcs12 -inkey admin-private-key.pem -in admin-cert.pem -export -out admin-q-user.pfx -passout pass:"StrongPassword"

# Create a keystore with the archives
keytool -genkeypair -alias admin -keyalg RSA -keypass StrongPassword -storepass StrongPassword -keystore server_keystore.jks -dname "CN=NiFi Server" -noprompt

# Create a truststore with keystore
keytool -importcert -v -trustcacerts -alias admin -file admin-cert.pem -keystore server_truststore.jks  -storepass StrongPassword -noprompt


### Creating keys to secondary nodes

# Create private key and certificate
openssl req -x509 -newkey rsa:2048 -keyout admin-private-key.pem -out admin-cert.pem -days 365 -subj "/CN=Nifi admin/C=MX/L=MexicoCity" -nodes

# Create a pair of keys
openssl pkcs12 -inkey admin-private-key.pem -in admin-cert.pem -export -out admin-q-user.pfx -passout pass:"StrongPassword"

# Create a keystore with the archives
keytool -genkeypair -alias admin -keyalg RSA -keypass StrongPassword -storepass StrongPassword -keystore server_keystore.jks -dname "CN=Nifi admin" -noprompt

# Create a truststore with keystore
keytool -importcert -v -trustcacerts -alias admin -file admin-cert.pem -keystore server_truststore.jks  -storepass StrongPassword -noprompt


