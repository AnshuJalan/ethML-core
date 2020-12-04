pragma solidity ^0.5.0;

import './EthMLStorageLib.sol';

/**
* @dev library functions for EthML.sol 
*/
library EthMLLib {

  //Constants for storage access
  bytes32 public constant requestCount = 0x05de9147d05477c0a5dc675aeea733157f5092f82add148cf39d579cafe3dc98;
  bytes32 public constant birth = 0x0f3fe971129295ad98fb77108128ec4c94083ec495d6ae9d7f14797c097eba91;
  bytes32 public constant tip = 0x9c35b68a5d39a44a5834c87c06e0905b483f5921b1cdeb093ce2cca2a2349a4c;
  bytes32 public constant difficulty = 0xb12aff7664b16cb99339be399b863feecd64d14817be7e1f042f97e3f358e64e;

  //Events
  event NewBlock(uint256 id, uint256 prediction); //Add rest of the values 

  /**
  * @notice 
  * @dev init_test sets up the genesis block and loads the proxy main with the initial mine.
  * this init is specifically for the ethMLToken testing.
  */
  function initTest(EthMLStorageLib.EthMLStorageStruct storage self) internal returns(bool) {
    self.balances[address(this)] = 2**256 - 1;

    // to test- ethMLPoW 
    self.currentChallenge = 0x289783b359a8ceaae95ebfc22d20253fd65753dd61e63796c88ab8f1f2f582d7;
    self.uintStorage[keccak256('difficulty')] = 1;

    // raw testing tokens
    self.balances[0x7CD86862A4AAA9E701CF255c2cE00fF13d50AD6F] = 1000 * 10**18;
    self.balances[0x4B5dB76845B70fE426cF82014D67A778931F62c7] = 1000 * 10**18;
    self.balances[0x184fb4e5FCe775244f2C5dEFEedF73f71c3351DD] = 1000 * 10**18;
    self.balances[0xc1A215d9355967d36D78248A57b6308D36aF4b25] = 1000 * 10**18;
    self.balances[0x4e150E015077eb2eF6cA1e9D66da81ca04729fDa] = 1000 * 10**18;
    self.balances[0xA7e2DADf5ca04C01Cc06307be44fA5543909FfBB] = 1000 * 10**18;

    self.uintStorage[keccak256('totalSupply')] = 6000 * 10**18;
  } 

  /**
  * @dev User contract can call this to add a request to the queue, along with a tip.
  * @param _modelId id of the model whose prediction we want
  * @param _dataPoint IPFS hash of the dataPoint 
  * @param _tip tip value in tokens. 0 for initial testing.
  */
  function requestPrediction(EthMLStorageLib.EthMLStorageStruct storage self, uint256 _modelId, string memory _dataPoint, uint256 _tip) internal returns(uint256){
    
    self.uintStorage[requestCount]++;
    uint256 id = self.uintStorage[requestCount];

    EthMLStorageLib.Request memory request;
    self.requestIdToRequest[id] = request;

    EthMLStorageLib.Request storage newRequest = self.requestIdToRequest[id];

    newRequest.modelId = _modelId;
    newRequest.dataPoint = _dataPoint;
    newRequest.caller = msg.sender;
    newRequest.requestId = id;
    newRequest.uintStorage[birth] = block.timestamp;
    newRequest.uintStorage[tip] = _tip;

    self.requestQ.push(id);

    //TODO: Deduct tip


    //TODO: Emit event
    return id;
  }

  function submitMiningSolution(EthMLStorageLib.EthMLStorageStruct storage self, 
    uint256 _id, 
    uint256 _prediction,
    uint256 _nonce) internal{
    EthMLStorageLib.Request storage request = self.requestIdToRequest[_id];

    //Only for testing. Remove during final build.
    self.uintStorage[difficulty] = 1;

    require(!request.miners[msg.sender], "Already submitted the value for the request.");

    _verifyNonce(self, _nonce);

    request.finalValues[request.predictionsReceived] = _prediction;
    request.miners[msg.sender] = true;
    request.predictionsReceived++;

    if(request.predictionsReceived == 5) {
      //TODO in main- new block formation


      //Call the user contract
      (bool result, ) = request.caller.call(abi.encodeWithSignature("requestCallback(uint256,uint256)", _id, _prediction));
      require(result, "Low level call failed!");

      emit NewBlock(_id, _prediction);
    }
  }

  /**
  * @dev helper function to verify the correctness of the nonce value sent in by the miners.
  */
  function _verifyNonce(EthMLStorageLib.EthMLStorageStruct storage self, uint256 _nonce) internal view {
    uint256 targetHashValue = uint256(self.currentChallenge) / self.uintStorage[difficulty];
    uint256 receivedUnderTargetHash = uint256(keccak256((abi.encodePacked(self.currentChallenge, msg.sender, _nonce))));
    require(targetHashValue > receivedUnderTargetHash, "Invalid nonce for the current challenge.");
  }

  /** 
  * Test function for EthML.test.js
  */
  function submitMiningSolutionTest(EthMLStorageLib.EthMLStorageStruct storage self, uint256 _id, uint256 _prediction) internal{
    EthMLStorageLib.Request storage request = self.requestIdToRequest[_id];

    // TODO in main- Verify nonce
    request.finalValues[request.predictionsReceived] = _prediction;
    request.predictionsReceived++;

    if(request.predictionsReceived == 5) {
      //TODO in main- new block formation

      //Call the user contract
      (bool result, ) = request.caller.call(abi.encodeWithSignature("requestCallback(uint256,uint256)", _id, _prediction));
      require(result, "Low level call failed!");

      emit NewBlock(_id, _prediction);
    }
  }
}