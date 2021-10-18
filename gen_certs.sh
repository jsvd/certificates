# warning: do not use the certificates produced by this tool in production. This is for testing purposes only

# certificate authority
openssl genrsa -out root.key 4096
openssl req -new -x509 -days 1826 -extensions ca -key root.key -out root.crt -subj "/C=PT/ST=NA/L=Lisbon/O=MyLab/CN=root" -config openssl.cnf


# intermediate CA
openssl genrsa -out intermediate-ca.key 4096
openssl req -new -key intermediate-ca.key -out intermediate-ca.csr -subj "/C=PT/ST=NA/L=Lisbon/O=MyLab/CN=intermediate-ca" -config openssl.cnf
openssl x509 -req -days 1000 -extfile ./openssl.cnf -extensions intermediate_ca -in intermediate-ca.csr -CA root.crt -CAkey root.key -out intermediate-ca.crt -set_serial 01

# server certificate from intermediate CA
openssl genrsa -out server_from_intermediate.key 4096
openssl req -new -key server_from_intermediate.key -out server_from_intermediate.csr -subj "/C=PT/ST=NA/L=Lisbon/O=MyLab/CN=server" -config openssl.cnf
openssl x509 -req -extensions server_cert -extfile ./openssl.cnf -days 1000 -in server_from_intermediate.csr -CA intermediate-ca.crt -CAkey intermediate-ca.key -set_serial 02 -out server_from_intermediate.crt

# server certificate from root
openssl genrsa -out server_from_root.key 4096
openssl req -new -key server_from_root.key -out server_from_root.csr -subj "/C=PT/ST=NA/L=Lisbon/O=MyLab/CN=server" -config openssl.cnf
openssl x509 -req -extensions server_cert -extfile ./openssl.cnf -days 1000 -in server_from_root.csr -CA root.crt -CAkey root.key -set_serial 03 -out server_from_root.crt


# client certificate from intermediate CA
openssl genrsa -out client_from_intermediate.key 4096
openssl req -new -key client_from_intermediate.key -out client_from_intermediate.csr -subj "/C=PT/ST=NA/L=Lisbon/O=MyLab/CN=client" -config openssl.cnf
openssl x509 -req -extensions client_cert -extfile ./openssl.cnf -days 1000 -in client_from_intermediate.csr -CA intermediate-ca.crt -CAkey intermediate-ca.key -set_serial 04 -out client_from_intermediate.crt

# client certificate from root
openssl genrsa -out client_from_root.key 4096
openssl req -new -key client_from_root.key -out client_from_root.csr -subj "/C=PT/ST=NA/L=Lisbon/O=MyLab/CN=client" -config openssl.cnf
openssl x509 -req -extensions client_cert -extfile ./openssl.cnf -days 1000 -in client_from_root.csr -CA root.crt -CAkey root.key -set_serial 04 -out client_from_root.crt

# verify :allthethings
openssl verify -CAfile root.crt intermediate-ca.crt
openssl verify -CAfile root.crt client_from_root.crt
openssl verify -CAfile root.crt server_from_root.crt
openssl verify -CAfile root.crt -untrusted intermediate-ca.crt client_from_intermediate.crt
openssl verify -CAfile root.crt -untrusted intermediate-ca.crt server_from_intermediate.crt

# create pkcs8 versions of all keys..sometimes they're handy
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in root.key -out root.key.pkcs8
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in intermediate-ca.key -out intermediate-ca.key.pkcs8
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in server_from_intermediate.key -out server_from_intermediate.key.pkcs8
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in server_from_root.key -out server_from_root.key.pkcs8
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in client_from_intermediate.key -out client_from_intermediate.key.pkcs8
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in client_from_root.key -out client_from_root.key.pkcs8
