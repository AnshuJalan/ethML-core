const EthMLMain = artifacts.require("EthMLMain");
const EthML = artifacts.require("EthML");
const UsingEthML = artifacts.require("UsingEthML");

module.exports = function (deployer) {
  deployer.deploy(EthML).then(() => {
    return deployer.deploy(EthMLMain, EthML.address).then(() => {
      return deployer.deploy(UsingEthML, EthMLMain.address);
    });
  });
};
