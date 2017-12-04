#!/bin/bash

# base directory defaults to current directory unless already set
GETH_TESTNET_BASEDIR="${GETH_TESTNET_BASEDIR:-.}"

GETH_TESTNET_JSDIR=${GETH_TESTNET_BASEDIR}/js
GETH_TESTNET_CHAINDIR=${GETH_TESTNET_BASEDIR}/chaindata

GETH_TESTNET_JSHELPER=${GETH_TESTNET_JSDIR}/useful-geth-snippets.js

GETH_ATTACH_POINT=${GETH_TESTNET_CHAINDIR}/geth.ipc

# parse command line arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --ipcdisable)
    GETH_ATTACH_POINT="http://localhost:8545"
	echo "== Attaching via RPC"
    shift # past argument
    ;;
esac
done

# attach to the node
geth --preload ${GETH_TESTNET_JSHELPER} attach ${GETH_ATTACH_POINT}
