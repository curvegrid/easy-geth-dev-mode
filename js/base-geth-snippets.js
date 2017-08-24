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