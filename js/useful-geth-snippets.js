var mining_threads = 1

// Create a wallet if one doesn't exist, and mine some Ether into it
if( personal.listAccounts.length === 0 ) {
  console.log("== No wallets found, creating one.");

  var password = ""
  var masterAcct = personal.newAccount(password);

  miner.setEtherbase(masterAcct);
  miner.start(mining_threads);
  admin.sleepBlocks(10);
  miner.stop();

  personal.unlockAccount(masterAcct, password);

  var balance = web3.fromWei(eth.getBalance(masterAcct), "ether");

  console.log("== New wallet '" + masterAcct + "' created with '" + balance + "' Ether mined to it.");
}

// Adapted from: https://ethereum.stackexchange.com/questions/2531/common-useful-javascript-snippets-for-geth 

// Mine only when there are transactions
function checkWork() {
    if (eth.getBlock("pending").transactions.length > 0) {
        if (eth.mining) return;
        console.log("== Pending transactions! Mining...");
        miner.start(mining_threads);
    } else if (eth.mining) {
        miner.stop();
        console.log("== No transactions! Mining stopped.");
    }
}

eth.filter("latest", function(err, block) { checkWork(); });
eth.filter("pending", function(err, block) { checkWork(); });

checkWork();

// Print all transactions for the last 1000 blocks

function getTransactionsByAccount(myaccount, startBlockNumber, endBlockNumber) {
  if (endBlockNumber == null) {
    endBlockNumber = eth.blockNumber;
    console.log("Using endBlockNumber: " + endBlockNumber);
  }
  if (startBlockNumber == null) {
    startBlockNumber = endBlockNumber - 1000;

    // Jeff: handle blockchains smaller than 1000 blocks
    if (startBlockNumber < 0) {
        startBlockNumber = 0
    }
    
    console.log("Using startBlockNumber: " + startBlockNumber);
  }
  console.log("Searching for transactions to/from account \"" + myaccount + "\" within blocks "  + startBlockNumber + " and " + endBlockNumber);

  for (var i = startBlockNumber; i <= endBlockNumber; i++) {
    if (i % 1000 == 0) {
      console.log("Searching block " + i);
    }
    var block = eth.getBlock(i, true);
    if (block != null && block.transactions != null) {
      block.transactions.forEach( function(e) {
        if (myaccount == "*" || myaccount == e.from || myaccount == e.to) {
          console.log("  tx hash          : " + e.hash + "\n"
            + "   nonce           : " + e.nonce + "\n"
            + "   blockHash       : " + e.blockHash + "\n"
            + "   blockNumber     : " + e.blockNumber + "\n"
            + "   transactionIndex: " + e.transactionIndex + "\n"
            + "   from            : " + e.from + "\n" 
            + "   to              : " + e.to + "\n"
            + "   value           : " + e.value + "\n"
            + "   time            : " + block.timestamp + " " + new Date(block.timestamp * 1000).toGMTString() + "\n"
            + "   gasPrice        : " + e.gasPrice + "\n"
            + "   gas             : " + e.gas + "\n"
            + "   input           : " + e.input);
        }
      })
    }
  }
}
