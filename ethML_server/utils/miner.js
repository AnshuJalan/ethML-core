const BN = require("bn.js");

class Miner {
  constructor(account) {
    this.account = account;
  }

  findUnderTargetHash(web3, challenge, difficulty) {
    const target = challenge.div(difficulty);
    console.log(target.toString());
    let nonce = 0;

    return new Promise((resolve) => {
      let calculatedHash = new BN("f".repeat(64), 16);
      while (calculatedHash.cmp(target) === 1) {
        nonce++;
        calculatedHash = new BN(
          web3.utils
            .soliditySha3(challenge.toString(), this.account, nonce)
            .slice(2),
          16
        );
      }

      resolve(nonce);
    });
  }
}

module.exports = Miner;
