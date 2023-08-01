const hre = require('hardhat');
const ethers = hre.ethers;

const path = require('path');

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());
  const ABS = await ethers.getContractFactory("Core", owner)
  core = await ABS.deploy()
  await core.deployed()
  console.log("address:", core.address);

}

// 0x0496275d34753A48320CA58103d5220d394FF77F - sepolia flash
// 0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb - polygon flash
// 0xE592427A0AEce92De3Edee1F18E0157C05861564 - swap router uniswap
// 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506 - swap router sushi
// 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff - swap router quick
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  }) 