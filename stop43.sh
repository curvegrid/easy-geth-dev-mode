#!/bin/bash

GETH_TESTNET_BASEDIR=.
GETH_TESTNET_CHAINDIR=${GETH_TESTNET_BASEDIR}/chaindata
GETH_TESTNET_LOGDIR=${GETH_TESTNET_CHAINDIR}/log

if [ -e ${GETH_TESTNET_LOGDIR}/geth.pid ]
then
	kill -INT $(cat ${GETH_TESTNET_LOGDIR}/geth.pid)
	rm ${GETH_TESTNET_LOGDIR}/geth.pid
fi
