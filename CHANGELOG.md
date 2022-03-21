# Changelog

# v3.0.0 - Binary default
Don't base64 encode encrypted messages by default.

**Breaking change:**
* `encrypt` and `encrypt-to` do not encode its output as base64 anymore
* `decrypt` and `decrypt-from` do not expect its inputs base64 encoded anymore

To encode it as base64, pipe the result to either `base64` or `openssl base64`:

```sh
$ echo "my secure message" | ./wcb.sh encrypt f44d7875d0151064afaf94f2e580d9a6fb8f57613bf73281d675362037b4ac8a | base64
$ echo "my secure message" | ./wcb.sh encrypt f44d7875d0151064afaf94f2e580d9a6fb8f57613bf73281d675362037b4ac8a | openssl base64
```

Decoding similar:

```sh
$ echo "poa1nQsvecGK4orSIUF+lm+nISQ/nFHkp81PrIEtJznGSsRXpDqoVPLIaIuDKPa3" | base64 -d | ./wcb.sh decrypt f44d7875d0151064afaf94f2e580d9a6fb8f57613bf73281d675362037b4ac8a
$ echo "poa1nQsvecGK4orSIUF+lm+nISQ/nFHkp81PrIEtJznGSsRXpDqoVPLIaIuDKPa3" | openssl base64 -d | ./wcb.sh decrypt f44d7875d0151064afaf94f2e580d9a6fb8f57613bf73281d675362037b4ac8a
```

## v2.0.0
Getting mature. This is a library now. CLI is here: [wcb.sh](https://github.com/jo/wcb-sh).

Includes breaking changes:
* no configurable ciphers anymore. Cipher is set to ECDH P-521 AES 256 GCM.
* include iv in ciphertext

New Features:
* encrypt and decrypt private key PEMs
* derive password from key pair


## v1.0.0
Initial version.
