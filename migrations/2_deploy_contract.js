const StrongHands = artifacts.require("StrongHands");


module.exports = function(deployer) {
  deployer.deploy(StrongHands, 100000);
};