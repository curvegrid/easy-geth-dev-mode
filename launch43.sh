#!/bin/bash

GETH_TESTNET_BASEDIR=.
GETH_TESTNET_JSDIR=${GETH_TESTNET_BASEDIR}/js
GETH_TESTNET_CHAINDIR=${GETH_TESTNET_BASEDIR}/chaindata
GETH_TESTNET_LOGDIR=${GETH_TESTNET_CHAINDIR}/log

GETH_TESTNET_JSHELPER=${GETH_TESTNET_JSDIR}/useful-geth-snippets.js

# create chaindir and logging folder tree if doesn't already exist
mkdir -p ${GETH_TESTNET_CHAINDIR}
mkdir -p ${GETH_TESTNET_LOGDIR}

# ensure local testnet geth isn't already running
if [ -e ${GETH_TESTNET_LOGDIR}/geth.pid ]
then
	echo "geth net43 testnet appears to be running or zombie pid file remains at '${GETH_TESTNET_LOGDIR}/geth.pid'"
	echo "Try running 'stop43.sh' to make it exit."
	exit 1
fi

# Do not enable RPC by default
if [ "--startrpc" == "$1" ]
then
	echo "== Enabling RPC"
	GETH_TESTNET_STARTRPC=${GETH_TESTNET_JSDIR}/start-rpc.js
else
	echo "== RPC is disabled! Use '$0 --startrpc' to enable."
	GETH_TESTNET_STARTRPC=""
fi

# launch geth in dev mode and set it to mine on pending transactions
# do not use 'console' command to avoid seeing all the mining log messages and to facilitate headless/daemon mode
geth --dev --datadir ${GETH_TESTNET_CHAINDIR} js ${GETH_TESTNET_JSHELPER} ${GETH_TESTNET_STARTRPC} >> ${GETH_TESTNET_LOGDIR}/geth.log 2>&1 &
echo $! > ${GETH_TESTNET_LOGDIR}/geth.pid

sleep 1

# attach to the node for interactive operation
${GETH_TESTNET_BASEDIR}/attach43.sh

# reminder to stop underlying geth at some point
echo -e "\n== Note that the underlying geth node is likely still running. Use 'stop43.sh' to exit it.\n"
