#!/bin/bash

die() {
	echo "$@"
	exit 1
}

function check_if_self_signed_keys_present_and_create_them_if_not() {
	local KEYDIR="./sys/certs"
	local KEYFILE="${KEYDIR}/default.key"
	local CERTFILE="${KEYDIR}/default.crt"
	local REQFILE="${KEYDIR}/request.csr"
	[[ -d "${KEYDIR}" ]] || mkdir -p "${KEYDIR}"
	echo "Checking whether self-signed certificates are in place ..."
	[[ -f "${KEYFILE}" ]] && [[ -f "${CERTFILE}" ]] && [[ -f "${REQFILE}" ]] || (
		echo "Generating private RSA key ..."
		openssl genrsa -out "${KEYFILE}" 2048 || die "Failed to generate ${KEYFILE}"
		echo "Creating a request file ..."
		openssl req -new -key "${KEYFILE}" -subj "/C=US/ST=State/L=City/O=Organization/CN=yourdomain.com" -out "${REQFILE}" || die "Failed to generate ${REQFILE}"
		echo "Creating a certificate file ..."
		openssl x509 -req -days 365000 -in "${REQFILE}" -signkey "${KEYFILE}" -out "${CERTFILE}" || die "Failed to generate ${CERTFILE}"
	)
}

check_if_self_signed_keys_present_and_create_them_if_not
