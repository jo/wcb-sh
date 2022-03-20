# Webcryptobox
WebCrypto compatible encryption with Bash and OpenSSL.

This CLI handles the [Webcryptobox](https://github.com/jo/webcryptobox) encryption API.

Compatible packages:
* [wcb JavaScript](https://github.com/jo/wcb-js)
* [wcb Rust](https://github.com/jo/wcb-rs)

See [Webcryptobox Bash](https://github.com/jo/webcryptobox-sh) for the library.


## Requirements
This script relies the following packages:

* OpenSSL
* cat, grep and xxd

Make sure they're installed on your system and globally callable.


## Usage
Call the `wcb.sh` script for usage information:

```sh
$ ./wcb.sh 
Usage: ./wcb.sh <COMMAND> [OPTIONS] [ARGUMENTS]

Symmetric encryption commands:
  key                                 - Generate symmetric key
  encrypt <KEY> [FILENAME]            - Encrypt message. Message either read from FILENAME or STDIN.
  decrypt <KEY> [FILENAME]            - Decrypt box. Box either read from FILENAME or STDIN.

Asymmetric encryption commands:
  private-key                         - Generate private key
  public-key [FILENAME]               - Get corresponding public key from private key, either specified via FILENAME or read from STDIN
  fingerprint [-h <HASH>] [FILENAME]  - Calculate fingerprint of public key, either specified via FILENAME or read from STDIN.
                                        You can use -h to specify the hash function, can be sha1 or sha256 (default).

  derive-key <PRIVATE_KEY> [PUBLIC_KEY]
                                      - Derive symmetric key from private and public key.
                                        Public key either specified via PUBLIC_KEY or read from STDIN.
  derive-password [-l LENGTH] <PRIVATE_KEY> [PUBLIC_KEY]
                                      - Derive password from private and public key.
                                        Use LENGTH from options, otherwise 128 bits.
                                        Public key either specified via PUBLIC_KEY or read from STDIN.

  encrypt-private-key <PASSWORD> [FILENAME]
                                      - Encrypt private key with password. Key either read from FILENAME or STDIN.
  decrypt-private-key <PASSWORD> [FILENAME]
                                      - Decrypt private key with password. Key either read from FILENAME or STDIN.

  encrypt-private-key-to <PRIVATE_KEY> <PUBLIC_KEY> [FILENAME]
                                      - Encrypt private key with private and public key. Private key either read from FILENAME or STDIN.
  decrypt-private-key-from <PRIVATE_KEY> <PUBLIC_KEY> [FILENAME]
                                      - Decrypt private key with private and public key. Private key either read from FILENAME or STDIN.

  encrypt-to <PRIVATE_KEY> <PUBLIC_KEY> [FILENAME]
                                      - Encrypt message with private and public key. Message either read from FILENAME or STDIN.
  decrypt-from <PRIVATE_KEY> <PUBLIC_KEY> [FILENAME]
                                      - Decrypt box with private and public key. Box either read from FILENAME or STDIN.
```

Note that keys and passwords are provided via arguments and therefore are visible eg. in `ps`, so that's not recommended if you need strong security. Reach out to me if using environment variables instead would be good fit, I'd be happy to add it.


## License
This project is licensed under the Apache 2.0 License.

© 2022 Johannes J. Schmidt
