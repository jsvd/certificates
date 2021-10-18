# certificates
The goal of this repo is to create a list of assets that can be used for testing TLS certificate validation.

Please never use these in Production!

Currently it produces keys and certificates for:

* a root certificate authoritity
* an intermediate certificate authority
* two client keys/certificates (one from the root, other from the intermediate)
* two server keys/certificates (one from the root, other from the intermediate)

NOTE: The certificates are regenerated twice a year with the help of a Github Action
