# Script utils
Utilities that I use to help configure and administer systems

## getca.py and getca.sh

These two scripts perform the same function, but in different ways.

### getca.sh

This is just a shell script that uses openssl in client mode to query an
endpoint for the TLS handshake. OpenSSL outputs the x509 cert chain, and it
uses sed tricks (swapping the hold and working buffer) to print the last
certificate in the chain.

### getca.py

This python implementation uses pyOpenSSL and network sockets to query a TLS
endpoint, performs the TLS handshake, and then outputs the last entry in the
x509 chain. It's a little cleaner, although the python3 implementation uses
`binary` data vs `string` data, so it needs to do a little decoding.

## realpath

On Darwin (MacOS) and possibly other Unix/Linux, the `realpath` command doesn't
exist. So I wrote a small one using python.

## y2j
Link to another project y2j or yaml to json

https://github.com/gonoph/y2j
