require('@nomiclabs/hardhat-waffle');
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: '0.8.0',
  
  gasReporter: {
    enabled: true,
    currency:  process.env.DOLAR_GAS,
    coinmarketcap: process.env.GAS_KEY,
    token: process.env.TOKEN,
    gasPriceApi: process.env.API_GAS,
    showTimeSpent: true,
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API,
  },
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_INFURA_URL,
      accounts: [process.env.PRIVATE_KEY],

    },
    goerly: {
      url: process.env.GOERLI_INFURA_URL,
      accounts: [process.env.PRIVATE_KEY],

    },
  },
};
