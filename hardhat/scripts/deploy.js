const { ethers } = require("hardhat");
require("dotenv").config({path: ".env"});
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");


async function main() {
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
  
  // URL to extract the metadata for a Crypto Dev NFT
  const metadataURL = METADATA_URL;
  
  // Is a factory for instances of our CryptoDevs contract
  const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs");

  const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
    metadataURL,
    whitelistContract
  );

  console.log(
    "Crypto Devs Contract Address:",
    deployedCryptoDevsContract.address
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
