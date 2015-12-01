
## TLS "Minimum Viable Product" Server

Bare-bones Mirage HTTP-over-TLS server. Pure TCP and `ocaml-tls`, serves a
static string.

# Build instructions

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
