try {
  admin.startRPC('localhost', 8545, 'http://localhost:8080', 'web3,eth,personal,net');
} catch(err) {
  console.log('Could not start RPC');
  console.log(err);
}
