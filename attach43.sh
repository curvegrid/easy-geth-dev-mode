#!/bin/bash

# base directory defaults to current directory unless already set
GETH_TESTNET_BASEDIR="${GETH_TESTNET_BASEDIR:-.}"

GETH_TESTNET_JSDIR=${GETH_TESTNET_BASEDIR}/js
GETH_TESTNET_CHAINDIR=${GETH_TESTNET_BASEDIR}/chaindata

GETH_TESTNET_JSHELPER=${GETH_TESTNET_JSDIR}/useful-geth-snippets.js

# attach to the node
geth --preload ${GETH_TESTNET_JSHELPER} attach ${GETH_TESTNET_CHAINDIR}/geth.ipc
