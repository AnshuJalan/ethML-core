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

    return id;
  }
}