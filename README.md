# EthML 🌐
> A decentralized machine learning implementation on Ethereum.

EthML is a fully functional prototype of a decentralized machine learning system, built on the Ethereum blockchain. Decentralized AI aims to combat the high degree of centralization in the field of AI by adding the aspect of distributed computing (here, Distributed Ledger Technology). EthML allows users to receive predictions from pre-trained ML models residing on a distributed computing network. Users upload the IPFS hash of a data-point & the model id of the model they want the prediction for to a smart contract deployed on Ethereum. This smart contract thereafter forwards the request to the mining system, which is a set of computers running the EthML-server & storing the models. These servers compute the prediction and upload the generated data along with a mining solution (used as a proof of work for utility token generation) back onto the smart contract, which then returns result to the user.

## Architecture
The design can be thought of as a two-layer structure. The base layer being the model network of computers that make the prediction and also finds the proof of work solution. The top layer would be formed of the set of managing smart contracts which would function as a virtual/logical chain on-top of the existing chain. This virtual chain would keep track of the requested predictions.

![EthML architecture](https://i.ibb.co/zmy2XSw/tuxpi-com-1608895635.jpg)

## Running Locally
This repo is a truffle project, consisting of the smart contracts and a server implemented in JS.

### Dependencies Installation

Clone Git repo:
``` 
git clone https://github.com/AnshuJalan/ethML-core.git 
```

Install truffle for deployment & ganache-cli for running a local blockchain:
```
npm i -g ganache-cli
npm i -g truffle
```

Install dependencies: 
``` 
npm install 
```

### Setup for testing

Start a local blockchain on localhost:8545 using ganache-cli. Note: Please use the mnemonic as stated below, as the accounts formed get prefunded with the tokens.
```
ganache-cli -m hawk couple problem quantum lemon lava saddle swallow want become forum educate
```

Deploy the contracts using truffle:
```
truffle migrate 
```

Start a minimum of 5 instances of EthML server, in 5 different terminal windows. Note: the digit given as flag denotes the account out of the 10 ganache generated accounts to be used by the server for sending transactions:
```
node ./ethML_server 0
node ./ethML_server 1
...
...
node ./ethML_server 4
```

### Testing

Start truffle console in a new terminal:
```
truffle console
```

In the truffle console, get the deployed instance of UsingEthML contract:
```
const instance = await UsingEthML.deployed()
```

Send a prediction request by calling the requestPrediction method is [UsingEthML contract](https://github.com/AnshuJalan/ethML-core/blob/master/contracts/user_contracts/UsingEthML.sol). You can use one of the pre-generated hashed provided in [testSeed file](https://github.com/AnshuJalan/ethML-core/blob/master/.testSeed):
```
await instance.requestPrediction(1, bafkreig4y5i3a6qf3ytuf6jyvwusz4dynvwctjofxv7ovu5nc5bz2ijuua, 0)
```

The running servers would catch the generated requests and start mining the result.

## Screenshots

Value Mining:

![Value Mining](https://i.ibb.co/Q98RMxh/1.png)

New Block:

![New Block](https://i.ibb.co/cYzJ7kP/2.png)

