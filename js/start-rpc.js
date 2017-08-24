try {
  admin.startRPC('localhost', 8545, 'http://localhost:*', 'web3,eth,personal,net');
} catch(err) {
  console.log('Could not start RPC');
  console.log(err);
}
