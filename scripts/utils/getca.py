#!/usr/bin/env python3

from socket import socket, AF_INET, SOCK_STREAM
import sys,os,datetime
try:
    from OpenSSL.SSL import Context, Connection, SSLv23_METHOD, OP_NO_SSLv2, OP_NO_SSLv3
    from OpenSSL.crypto import FILETYPE_PEM, dump_certificate
except ModuleNotFoundError as ex:
    print('ERROR: You need to install OpenSSL, try pip3 install pyOpenSSL', file=sys.stderr)
    raise ex

def xjoin(list_of_lists):
    return ",".join(map(lambda x: "=".join(map(lambda y: y.decode(), x)), list_of_lists))

def datestr(dt):
    try:
        return str(datetime.datetime.strptime(dt.decode(), "%Y%m%d%H%M%SZ"))
    except:
        return str(dt)

FMT="""i: {}
s: {}
Valid
    Not Before: {}
    Not After : {}"""

def walkchain(cert_chain):
    chain = cert_chain[1:]
    for cert in chain:
        print(FMT.format(
            xjoin(cert.get_issuer().get_components()),
            xjoin(cert.get_subject().get_components()),
            datestr(cert.get_notBefore()),
            datestr(cert.get_notAfter())))
        print(dump_certificate(FILETYPE_PEM, cert).decode())
    return chain

def printcert(host, port, hostname):
    context = Context(SSLv23_METHOD)
    context.set_options(OP_NO_SSLv2)
    context.set_options(OP_NO_SSLv3)
    con = Connection(context, socket(AF_INET, SOCK_STREAM))
    con.connect((host, port))
    con.set_tlsext_host_name(hostname.encode('utf8') if hostname else host.encode('utf8'))
    con.do_handshake()
    con.shutdown()
    con.close()
    walkchain(con.get_peer_cert_chain())

def main():
    args = sys.argv
    args.reverse()
    prog = args.pop()

    if len(args) < 1:
        print(f'Usage {os.path.basename(prog)} host[:port] [hostname if different from host]')
        sys.exit(1)

    split = args.pop().split(':')[::-1]
    host = split.pop()
    port = int(split.pop()) if split else 443
    hostname = args.pop() if args else None

    printcert(host, port, hostname)

if __name__ == '__main__':
    main()
