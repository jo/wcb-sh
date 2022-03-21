#!/usr/bin/env bash

# WebCrypto compatible cryptography CLI
# Version: 3.0.0

set -eo pipefail

. webcryptobox.sh

usage () {
  echo "Usage: ${0} <COMMAND> [OPTIONS] [ARGUMENTS]"
  echo
  echo "Symmetric encryption commands:"
  echo "  key                             - Generate symmetric key"
  echo "  encrypt <KEY> [FILENAME]        - Encrypt message. Message either read from FILENAME or STDIN."
  echo "  decrypt <KEY> [FILENAME]        - Decrypt box. Box either read from FILENAME or STDIN."
  echo
  echo "Asymmetric encryption commands:"
  echo "  private-key                     - Generate private key"
  echo "  public-key [FILENAME]           - Get corresponding public key from private key, either specified via FILENAME or read from STDIN"
  echo "  fingerprint [-s <SHA_TYPE>] [FILENAME]"
  echo "                                  - Calculate fingerprint of public key, either specified via FILENAME or read from STDIN."
  echo "                                    You can use -s to specify the sha type, can be sha1 or sha256 (default)."
  echo
  echo "  derive-key <PRIVATE_KEY> [PUBLIC_KEY]"
  echo "                                  - Derive symmetric key from private and public key."
  echo "                                    Public key either specified via PUBLIC_KEY or read from STDIN."
  echo "  derive-password [-l LENGTH] <PRIVATE_KEY> [PUBLIC_KEY]"
  echo "                                  - Derive password from private and public key."
  echo "                                    Use LENGTH from options, otherwise 16 bytes."
  echo "                                    Public key either specified via PUBLIC_KEY or read from STDIN."
  echo
  echo "  encrypt-private-key <PASSWORD> [FILENAME]"
  echo "                                  - Encrypt private key with password. Key either read from FILENAME or STDIN."
  echo "  decrypt-private-key <PASSWORD> [FILENAME]"
  echo "                                  - Decrypt private key with password. Key either read from FILENAME or STDIN."
  echo
  echo "  encrypt-private-key-to <PRIVATE_KEY> <PUBLIC_KEY> [FILENAME]"
  echo "                                  - Encrypt private key with private and public key. Private key either read from FILENAME or STDIN."
  echo "  decrypt-private-key-from <PRIVATE_KEY> <PUBLIC_KEY> [FILENAME]"
  echo "                                  - Decrypt private key with private and public key. Private key either read from FILENAME or STDIN."
  echo
  echo "  encrypt-to <PRIVATE_KEY> <PUBLIC_KEY> [FILENAME]"
  echo "                                  - Encrypt message with private and public key. Message either read from FILENAME or STDIN."
  echo "  decrypt-from <PRIVATE_KEY> <PUBLIC_KEY> [FILENAME]"
  echo "                                  - Decrypt box with private and public key. Box either read from FILENAME or STDIN."
}


if [ ! 0 == $# ]
then
  subcommand="$1"; shift

  case "${subcommand}" in
    key )
      key
      ;;

    encrypt )
      key=""
      filename=""
      if [ "${#}" -eq 1 ]; then
        key="${1}"
        filename="-"
      elif [ "${#}" -eq 2 ]; then
        key="${1}"
        filename="${2}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      encrypt "${key}" "${filename}"
      ;;

    decrypt )
      key=""
      filename=""
      if [ "${#}" -eq 1 ]; then
        key="${1}"
        filename="-"
      elif [ "${#}" -eq 2 ]; then
        key="${1}"
        filename="${2}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      decrypt "${key}" "${filename}"
      ;;


    private-key )
      private_key
      ;;

    public-key )
      filename=""
      if [ "${#}" -eq 1 ]; then
        filename="${1}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      public_key "${filename}"
      ;;

    fingerprint )
      hashfunction=""
      while getopts ":s:" opt; do
        case "${opt}" in
          s )
            case "${OPTARG}" in
              sha1|sha256 )
                hashfunction="${OPTARG}"
              ;;
              * )
                echo "[ERROR]: Invalid value for sha parameter -s: ${OPTARG}. Must be either 'sha1' or 'sha256'."
                usage
                exit 1
              ;;
            esac
          ;;
          ? )
            echo "[ERROR]: Invalid option: -${OPTARG}"
            usage
            exit 1
          ;;
        esac
      done
      if [ -z "${hashfunction}" ]; then
        hashfunction="sha256"
      fi
      shift $(( OPTIND-1 ))
      filename=""
      if [ "${#}" -eq 0 ]; then
        filename="-"
      elif [ "${#}" -eq 1 ]; then
        filename="${1}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      fingerprint "${filename}" "${hashfunction}"
      ;;


    derive-key )
      private_key=""
      public_key=""
      if [ "${#}" -eq 1 ]; then
        private_key="${1}"
        public_key="-"
      elif [ "${#}" -eq 2 ]; then
        private_key="${1}"
        public_key="${2}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      derive_key "${private_key}" "${public_key}"
      ;;

    derive-password )
      length=""
      while getopts ":l:" opt; do
        case "${opt}" in
          l )
            length="${OPTARG}"
          ;;
          ? )
            echo "[ERROR]: Invalid option: -${OPTARG}"
            usage
            exit 1
          ;;
        esac
      done
      if [ -z "${length}" ]; then
        length="16"
      fi
      if [ "${length}" -lt 1 ]; then
        echo "[ERROR]: password too short, minimum is 1 byte: ${length}"
        exit 1
      fi
      if [ "${length}" -gt 32 ]; then
        echo "[ERROR]: password too long, maximum is 32 bytes: ${length}"
        exit 1
      fi
      shift $(( OPTIND-1 ))
      private_key=""
      public_key=""
      if [ "${#}" -eq 1 ]; then
        private_key="${1}"
        public_key="-"
      elif [ "${#}" -eq 2 ]; then
        private_key="${1}"
        public_key="${2}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      derive_password "${private_key}" "${public_key}" "${length}"
      ;;

    
    encrypt-private-key )
      password=""
      filename=""
      if [ "${#}" -eq 1 ]; then
        password="${1}"
        filename="-"
      elif [ "${#}" -eq 2 ]; then
        password="${1}"
        filename="${2}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      encrypt_private_key "${password}" "${filename}"
      ;;

    decrypt-private-key )
      password=""
      filename=""
      if [ "${#}" -eq 1 ]; then
        password="${1}"
        filename="-"
      elif [ "${#}" -eq 2 ]; then
        password="${1}"
        filename="${2}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      decrypt_private_key "${filename}" "${filename}"
      ;;

 
    encrypt-private-key-to )
      private_key=""
      public_key=""
      filename=""
      if [ "${#}" -eq 2 ]; then
        private_key="${1}"
        public_key="${2}"
        filename="-"
      elif [ "${#}" -eq 3 ]; then
        private_key="${1}"
        public_key="${2}"
        filename="${3}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      encrypt_private_key_to "${private_key}" "${public_key}" "${filename}"
      ;;

    decrypt-private-key-from )
      private_key=""
      public_key=""
      filename=""
      if [ "${#}" -eq 2 ]; then
        private_key="${1}"
        public_key="${2}"
        filename="-"
      elif [ "${#}" -eq 3 ]; then
        private_key="${1}"
        public_key="${2}"
        filename="${3}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      decrypt_private_key_from "${private_key}" "${public_key}" "${filename}"
      ;;


    encrypt-to )
      private_key=""
      public_key=""
      filename=""
      if [ "${#}" -eq 2 ]; then
        private_key="${1}"
        public_key="${2}"
        filename="-"
      elif [ "${#}" -eq 3 ]; then
        private_key="${1}"
        public_key="${2}"
        filename="${3}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      encrypt_to "${private_key}" "${public_key}" "${filename}"
      ;;

    decrypt-from )
      private_key=""
      public_key=""
      filename=""
      if [ "${#}" -eq 2 ]; then
        private_key="${1}"
        public_key="${2}"
        filename="-"
      elif [ "$#" -eq 3 ]; then
        private_key="${1}"
        public_key="${2}"
        filename="${3}"
      else
        echo "invalid parameters"
        usage
        exit 1
      fi
      decrypt_from "${private_key}" "${public_key}" "${filename}"
      ;;


    * )
      if [ ! -z "${subcommand}" ]; then
        echo "command not found: ${subcommand}"
      fi
      usage
      exit 1
      ;;
  esac
else
  usage
  exit 1
fi
