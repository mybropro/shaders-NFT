var shadernft = artifacts.require("ShaderNFT");

const url = "https://ipfs.io/ipfs/QmZ3kbMASNEYQb1RiQfXTLL5g6xrRTCToZSxERt2JjruZJ"
module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(shadernft, url);
};
