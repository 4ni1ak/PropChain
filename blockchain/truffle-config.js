module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 6721975,
      gasPrice: 20000000000,
    },
    docker: {
      host: "ganache",
      port: 8545,
      network_id: "5777",
    }
  },
  compilers: {
    solc: {
      version: "0.8.19",
    }
  }
};
