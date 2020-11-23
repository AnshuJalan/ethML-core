const UsingEthML = artifacts.require("UsingEthML");
const EthMLMain = artifacts.require("EthMLMain");
const EthMLAbi = require("../../build/contracts/EthML.json").abi;

contract("UsingEthML", async (accounts) => {
  let usingEthML, ethML;

  const [alice, bob, john, mike, dave, chris] = accounts;

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
      from: alice,
    });

    //Miners (5) submits data
    const data = web3.eth.abi.encodeFunctionCall(EthMLAbi[1], [1, 356]);
    await ethML.sendTransaction({
      from: bob,
      data,
    });
    await ethML.sendTransaction({
      from: john,
      data,
    });
    await ethML.sendTransaction({
      from: mike,
      data,
    });
    await ethML.sendTransaction({
      from: chris,
      data,
    });
    const result = await ethML.sendTransaction({
      from: dave,
      data,
    });

    assert(result.logs[0].args.prediction.toNumber() === 356);
  });

  it("UsingEthML receives the request", async () => {
    const res = await usingEthML.getLatestResponse();
    assert(res.toNumber() === 356);
  });
});
