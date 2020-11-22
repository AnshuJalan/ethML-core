pragma solidity ^0.5.0;

import './libraries/EthMLStorageLib.sol';
import './libraries/EthMLLib.sol';

/**
* @dev The main upgradeable implementation of EthML. 
* This allows users to request for predictions, addTip to requests, and
* the miners can submit solutions.
*/
contract EthML {

  using EthMLLib for EthMLStorageLib.EthMLStorageStruct;

  EthMLStorageLib.EthMLStorageStruct ethML;

  function requestPrediction(uint256 _modelId,string calldata _dataPoint,uint256 _tip) external returns(uint256){
    return ethML.requestPrediction(_modelId, _dataPoint, _tip);
  }
}