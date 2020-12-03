const UsingEthML = artifacts.require("UsingEthML");
const EthMLMain = artifacts.require("EthMLMain");
const EthMLAbi = require("../../build/contracts/EthML.json").abi;

contract("EthMLMain", async (accounts) => {
  let usingEthML, ethML;

  //const [alice, bob, john, mike, dave, chris] = accounts;

  it("is deployed properly", async () => {
    ethML = await EthMLMain.deployed();
    usingEthML = await UsingEthML.deployed();
    assert(ethML.address !== "");
    assert(usingEthML.address !== "");
  });

  it("allows submission of data", async () => {
    //Request for prediction through UsingEthML contract
    const dataPoint = "QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D";
    const modelId = 1;
    const tip = 0;
    await usingEthML.requestPrediction(modelId, dataPoint, tip, {
      from: accounts[0],
    });

    const challenge =
      "0x289783b359a8ceaae95ebfc22d20253fd65753dd61e63796c88ab8f1f2f582d7";

    let res;

    for (let i = 1; i < 6; i++) {
      let nonce = 0;
      let result = BigInt("0x" + "f".repeat(64));
      while (result > BigInt(challenge)) {
        nonce++;
        result = BigInt(web3.utils.soliditySha3(challenge, accounts[i], nonce));
      }
      let data = web3.eth.abi.encodeFunctionCall(EthMLAbi[1], [1, 356, nonce]);
      res = await ethML.sendTransaction({
        from: accounts[i],
        data,
      });
    }

    assert(res.logs[0].args.prediction.toNumber() === 356);
  });

  it("UsingEthML receives the request", async () => {
    const res = await usingEthML.getLatestResponse();
    assert(res.toNumber() === 356);
  });
});
