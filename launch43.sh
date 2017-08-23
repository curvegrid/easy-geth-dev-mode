#!/bin/bash

LETH_TESTNET_BASEDIR=.
LETH_TESTNET_JSDIR=${LETH_TESTNET_BASEDIR}/js
LETH_TESTNET_CHAINDIR=${LETH_TESTNET_BASEDIR}/chaindata
LETH_TESTNET_LOGDIR=${LETH_TESTNET_CHAINDIR}/log

LETH_TESTNET_JSHELPER=${LETH_TESTNET_JSDIR}/useful-geth-snippets.js

# create chaindir and logging folder tree if doesn't already exist
mkdir -p ${LETH_TESTNET_CHAINDIR}
mkdir -p ${LETH_TESTNET_LOGDIR}

# ensure local testnet geth isn't already running
if [ -e ${LETH_TESTNET_LOGDIR}/geth.pid ]
then
	echo "geth net43 testnet appears to be running or zombie pid file remains at '${LETH_TESTNET_LOGDIR}/geth.pid'"
	echo "Try running 'stop43.sh' to make it exit."
	exit 1
fi

# Do not enable RPC by default
if [ "--startrpc" == "$1" ]
then
	echo "== Enabling RPC"
	LETH_TESTNET_STARTRPC=${LETH_TESTNET_JSDIR}/start-rpc.js
else
	echo "== RPC is disabled! Use '$0 --startrpc' to enable."
	LETH_TESTNET_STARTRPC=""
fi

# launch geth in dev mode and set it to mine on pending transactions
# do not use 'console' command to avoid seeing all the mining log messages and to facilitate headless/daemon mode
geth --dev --datadir ${LETH_TESTNET_CHAINDIR} js ${LETH_TESTNET_JSHELPER} ${LETH_TESTNET_STARTRPC} >> ${LETH_TESTNET_LOGDIR}/geth.log 2>&1 &
echo $! > ${LETH_TESTNET_LOGDIR}/geth.pid

sleep 1

# attach to the node for interactive operation
${LETH_TESTNET_BASEDIR}/attach43.sh

# reminder to stop underlying geth at some point
echo -e "\n== Note that the underlying geth node is likely still running. Use 'stop43.sh' to exit it.\n"
