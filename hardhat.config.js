require("@nomicfoundation/hardhat-toolbox");
const PRIVATE_KEY = ""

module.exports = {
  solidity: "0.8.18",
  networks: {
    hardhat: {
      forking: {
        url: "https://eth-mainnet.g.alchemy.com/v2/xTfnNvnfFHQDwdMOlqdC70UQ5y8bf7wU",
        blockNumber: 17804694
      },
      sepolia: {
        url: "https://eth-sepolia.g.alchemy.com/v2/iqkbNPL-nQ-FLGDhb0-80vav1-5ZrF37",
        chainId: 11155111,
        accounts: [
          PRIVATE_KEY
        ],
      },
      goerli: {
        url: "https://eth-goerli.g.alchemy.com/v2/pNB2B0YbVdRTAslya-vu0CZZEcnmfgXG",
        chainId: 5,
        accounts: [
          PRIVATE_KEY
        ],
      },
      main: {
        url: "https://eth-mainnet.g.alchemy.com/v2/TubV4FkNPNOe-ZC246N0AEVGS22umkWy",
        chainId: 1,
        accounts: [
          PRIVATE_KEY
        ],
      },
      polygon: {
        url: "https://polygon-mainnet.g.alchemy.com/v2/i6mT1lOyoZlizAMfrSNR5cI01ifZDGjT",
        chainId: 137,
        accounts: [
          PRIVATE_KEY
        ],
      }
    }

    
  }
};
