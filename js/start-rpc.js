try {
  admin.startRPC('localhost', 8545, 'http://localhost:*', 'web3,eth,personal,net,debug,admin');
} catch(err) {
  console.log('Could not start RPC');
  console.log(err);
}
