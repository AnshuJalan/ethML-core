const UsingEthML = artifacts.require("UsingEthML");
const EthMLMain = artifacts.require("EthMLMain");

contract("UsingEthML", async (accounts) => {
  let instance;

  const [alice] = accounts;

  it("is deployed properly", async () => {
    instance = await UsingEthML.deployed();
    assert(instance.address !== "");
  });

  it("allows user to request data", async () => {
    const dataPoint = "QmTkzDwWqPbnAh5YiV5VwcTLnGdwSNsNTn2aDxdXBFca7D";
    const modelId = 1;
    const tip = 0;

    const result = await instance.requestPrediction(modelId, dataPoint, tip, {
      from: alice,
    });

    assert(result.logs[0].args.requestId.toNumber() === 1);
  });

  it("EthML receives the request", async () => {
    const oracleInstance = await EthMLMain.deployed();
    const requestCountHash =
      "0x05de9147d05477c0a5dc675aeea733157f5092f82add148cf39d579cafe3dc98";
    const res = await oracleInstance.getUintStorage(requestCountHash);

    assert(res.toNumber() === 1);
  });
});
