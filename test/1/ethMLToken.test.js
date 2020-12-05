const EthMLMain = artifacts.require("EthMLMain");
const UsingEthML = artifacts.require("UsingEthML");
const EthMLAbi = require("../../build/contracts/EthML.json").abi;
const BN = require("bn.js");

contract("EthMLToken", async (accounts) => {
  let ethML, usingEthML;
  const [alice, bob, john, mike, dave, chris] = accounts;

  beforeEach(async () => {
    ethML = await EthMLMain.deployed();
    usingEthML = await UsingEthML.deployed();
  });

  it("has tokens", async () => {
    const supply = await ethML.totalSupply();
    assert(supply.toString() === "6000000000000000000000");
  });

  it("allows transfer of tokens", async () => {
    const data = web3.eth.abi.encodeFunctionCall(EthMLAbi[6], [
      bob,
      new BN("1000000000000000000000", 10),
    ]);
    await ethML.sendTransaction({
      from: alice,
      data,
    });
    const bal = await ethML.balanceOf(bob);
    assert(bal.toString() === "2000000000000000000000");
  });

  it("allows cross transfer of tokens", async () => {
    const data = web3.eth.abi.encodeFunctionCall(EthMLAbi[7], [
      bob,
      john,
      new BN("2000000000000000000000", 10),
    ]);
    await ethML.sendTransaction({
      from: alice,
      data,
    });
    const bal = await ethML.balanceOf(john);
    assert(bal.toString() === "3000000000000000000000");
  });

  it("allows tip transfers", async () => {
    const data = web3.eth.abi.encodeFunctionCall(EthMLAbi[6], [
      usingEthML.address,
      new BN("1000000000000000000000", 10),
    ]);
    await ethML.sendTransaction({
      from: john,
      data,
    });

    let bal;

    await usingEthML.requestPrediction(1, "Hello", "500000000000000000000");

    bal = await ethML.balanceOf(ethML.address);
    assert(bal.toString() === "500000000000000000000");
  });
});
