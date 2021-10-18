all:
	./gen_certs.sh

clean:
	rm -rf *.crt *.key* *.csr
