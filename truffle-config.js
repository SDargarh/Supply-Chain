const path = require("path");
const { mnemonic, API_KEY } = require('./secrets.json');
var HDWalletProvider = require("./client/node_modules/truffle-hdwallet-provider");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    develop: {
      port: 8545
    },

    rinkeby: {
      provider: () => {
        return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/' + API_KEY)
      },
      network_id: 4,
      gas: 4000000
    }
  },
  compilers: {
    solc: {
      version: "0.6.1"
    }
  }
};
