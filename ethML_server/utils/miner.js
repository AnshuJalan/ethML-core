const BN = require("bn.js");
const logUpdate = require("log-update");
const chalk = require("chalk");
const cliSpinners = require("cli-spinners");

const { frames } = cliSpinners["dots"];

class Miner {
  constructor(account) {
    this.account = account;
  }

  findUnderTargetHash(web3, challenge, difficulty) {
    const target = challenge.div(difficulty);
    let nonce = 0;
    let i = 0;

    logUpdate.done();

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

        logUpdate(
          frames[(i = ++i % frames.length)] +
            ` Mining ${chalk.greenBright(nonce)}`
        );
      }

      logUpdate.clear();
      resolve(nonce);
    });
  }
}

module.exports = Miner;
