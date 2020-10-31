pragma solidity ^0.5.0;

import './libraries/SafeMath.sol';
import './libraries/EthMLStorageLib.sol';
import './libraries/EthMLGettersLib.sol';

/**
* @title EthML storage
* @dev Has external storage getter functions. 
* The logic resides in Transfer, Getters and Stake (in future) library. 
*/

contract EthMLStorage{

  using SafeMath for uint256;
  using EthMLGettersLib for EthMLStorageLib.EthMLStorageStruct;

  EthMLStorageLib.EthMLStorageStruct ethML;

  function getAddressStorage(bytes32 _data) external view returns(address) {
    return ethML.getAddressStorage(_data);
  }

  function getUintStorage(bytes32 _data) external view returns(uint256) {
    return ethML.getUintStorage(_data);
  }
}