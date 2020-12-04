pragma solidity ^0.5.0;

import './libraries/EthMLStorageLib.sol';
import './libraries/EthMLTransferLib.sol';
import './libraries/EthMLLib.sol';

/**
* @dev The main upgradeable implementation of EthML. 
* This allows users to request for predictions, addTip to requests, and
* the miners can submit solutions.
*/
contract EthML {

  using EthMLLib for EthMLStorageLib.EthMLStorageStruct;
  using EthMLTransferLib for EthMLStorageLib.EthMLStorageStruct;

  EthMLStorageLib.EthMLStorageStruct ethML;

  /** 
  * @dev calls the library function to handle requests in EthMLLib
  */
  function requestPrediction(uint256 _modelId,string calldata _dataPoint,uint256 _tip) external returns(uint256){
    return ethML.requestPrediction(_modelId, _dataPoint, _tip);
  }

  /**
  * @dev Allows miners to submit the requested prediction along with the POW nonce.
  */
  function submitMiningSolution(uint256 _id, uint256 _prediction, uint256 _nonce) external {
    ethML.submitMiningSolution(_id, _prediction, _nonce);
  }

  /**
  * Test function to accept mining solution and requested prediction value.
  * Test written in ethMl.test.js
  */
  function submitMiningSolutionTest(uint256 _id, uint256 _prediction) external {
    ethML.submitMiningSolutionTest(_id, _prediction);
  }

  /* Utility token functions */
  function name() external pure returns(string memory) {
    return "EthML Token";
  }

  function symbol() external pure returns(string memory) {
    return "EML";
  }

  function decimals() external pure returns(uint256) {
    return 18;
  }

  /**
  * @dev for testing ethMlToken
  */
  function transferTest(address _to, uint256 _value) external returns(bool) {
    return ethML.transferTest(_to, _value);
  }

   /**
  * @dev for testing ethMlToken
  */
  function transferFromTest(address _from, address _to, uint256 _value) external returns(bool) {
    return ethML.transferFromTest(_from, _to, _value);
  }

  function transfer(address _to, uint256 _value) external returns(bool) {
    return ethML.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) external returns(bool) {
    return ethML.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) external returns(bool){
    return ethML.approve(_spender, _value);
  }
}