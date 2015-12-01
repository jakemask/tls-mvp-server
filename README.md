# TLS "Minimum Viable Product" Server

Bare-bones Mirage TLS server. Pure TCP and `ocaml-tls`, serves a
static string.

## Build instructions

First follow the instructions over at https://mirage.io/wiki/install to install
Mirage.

Then run

```bash
$ NET=socket mirage configure --unix
...
$ make
...
$ ./mir-tls-server
```

Then it will be running a tls server at port 4433. If you connect succesfully,
it will send a short message and then close the connection.
