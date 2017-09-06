try {
  admin.startRPC('localhost', 8545, 'http://localhost:*', 'web3,eth,personal,net,debug');
} catch(err) {
  console.log('Could not start RPC');
  console.log(err);
}
