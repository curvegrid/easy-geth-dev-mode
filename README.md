# Easy Geth Dev Mode
Simple scripts to launch geth (Go Ethereum) in dev mode

## Introduction
Geth (Go Ethereum) dev mode is a way of starting geth with a default genesis block and low proof of work setting that never increases. Mining is very fast (~1 second/block) even on constrained hardware, such as an old laptop. The chain data directory occupies a few kilobytes. Other sane settings are also set behind the scenes, such as disabled RPC and max peer count of 1.

The scripts contained in this repo make things even easier, by providing single command launch, attach and stop functionality; auto-mining when transactions are waiting; auto-creating coinbase account and mine some Ether to it at first run; hiding mining console output; and optional RPC enablement.

For more on the details of geth dev mode in general, see our [blog post](http://blog.curvegrid.com/daysofblock/2017/06/14/daysofblock-05-testing-dapp-first-principles.html#gethdevmode) on the subject.

## Usage
This has been tested on macOS and Linux. Cygwin on Windows might also work out of the box.

First, clone the repo. We'll clone it into a directory called `net43`, which is just a play on the fact that 42 is a commonly used network ID for test networks and 43 is one more than that.

```sh
git clone https://github.com/curvegrid/easy-geth-dev-mode.git ./net43
```

Three shell scripts are provided:

* `launch43.sh`: Launch an underlying geth instance in dev mode in order hide mining console output, then attach to it with an interactive geth instance. RPC is disabled by default but can be enabled by specifying the `--startrpc` command line option.

* `attach43.sh`: Attach an interactive geth instance to the underlying geth instance. This can be run multiple times concurrently. Geth attaches via IPC.

* `stop43.sh`: Quit the underlying geth instance. Any additionally attached instances will continue to run and will need to be exited via CTRL+C or by typing `exit` assuming they are interactive, or killing them manually if they are not.

## Sample Run
```sh
$ cd net43
$ ls
README.md   attach43.sh chaindata   js          launch43.sh stop43.sh
$ ./launch43.sh
== RPC is disabled! Use './launch43.sh --startrpc' to enable.
Welcome to the Geth JavaScript console!

instance: Geth/v1.6.1-stable-021c3c28/darwin-amd64/go1.8.1
coinbase: 0x49ea302faac79abc5875b282d1c50bd5f319fc16
at block: 11 (Wed, 23 Aug 2017 10:35:30 JST)
 datadir: /Users/jeff/projects/curvegrid/consensysacademy/net43/chaindata
 modules: admin:1.0 debug:1.0 eth:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 shh:1.0 txpool:1.0 web3:1.0

>
> // Note that auto-mining is enabled, so mining will start if transactions 
> // are pending and will stop if no transactions are pending
>
> personal.unlockAccount(eth.accounts[0])
Unlock account 0x49ea302faac79abc5875b282d1c50bd5f319fc16
Passphrase: 
true
> var txHash = eth.sendTransaction({ from: eth.accounts[0], data: "0x6003600501600203600053" })
undefined
> eth.getTransactionReceipt(txHash)
{
  blockHash: "0x491d815305875bf2a080edec3e9d393027953c9a089eaff037b2e02576092f3e",
  blockNumber: 13,
  contractAddress: "0x268066bf71717c0a76c500cf4a3abda1a4e8c87b",
  cumulativeGasUsed: 53708,
  from: "0x49ea302faac79abc5875b282d1c50bd5f319fc16",
  gasUsed: 53708,
  logs: [],
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  root: "0x274cb39cd6f1b58308e0d65b09a17266660d97fc72860cacd3a234563020b53e",
  to: null,
  transactionHash: "0x9697f0700bd742df516487f2b69e6bdeeea07f6e1a786541bb323fe12823fb50",
  transactionIndex: 0
>
> exit

== Note that the underlying geth node is likely still running. Use 'stop43.sh' to exit it.

$ ./attach43.sh
Welcome to the Geth JavaScript console!

instance: Geth/v1.6.1-stable-021c3c28/darwin-amd64/go1.8.1
coinbase: 0x49ea302faac79abc5875b282d1c50bd5f319fc16
at block: 11 (Wed, 23 Aug 2017 10:35:30 JST)
 datadir: /Users/jeff/projects/curvegrid/consensysacademy/net43/chaindata
 modules: admin:1.0 debug:1.0 eth:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 shh:1.0 txpool:1.0 web3:1.0

> 
> exit
$ ./stop43.sh 
$
```

## Useful geth snippets
The JavaScript code in `js/useful-geth-snippets.js` is preloaded into geth by `launch43.sh` and `attach43.sh`. It contains the auto-mining code along with a utility function `getTransactionsByAccount()` which prints select or all transactions within the last 1000 blocks mined. This file would be a good place to place other snippets you would like pre-loaded into geth.