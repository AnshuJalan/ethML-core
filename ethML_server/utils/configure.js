const Web3 = require("web3");
const EthMLProxy = require("../../build/contracts/EthMLMain.json");
const EthML = require("../../build/contracts/EthML.json");

async function init() {
  const web3 = new Web3("ws://localhost:8545");

  const networkId = await web3.eth.net.getId();
  const ethMLInstance = new web3.eth.Contract(
    EthMLProxy.abi,
    EthMLProxy.networks[networkId].address
  );
  return {
    web3,
    ethMLAbi: EthML.abi,
    ethML: ethMLInstance,
  };
}

module.exports = {
  init,
};
