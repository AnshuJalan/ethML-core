pragma solidity ^0.5.0;

import './libraries/SafeMath.sol';
import './libraries/EthMLStorageLib.sol';
import './libraries/EthMLGettersLib.sol';
import './libraries/EthMLTransferLib.sol';
import './libraries/EthMLLib.sol';

/**
* @title EthML storage
* @dev Has external storage getter functions. 
* The logic resides in Transfer, Getters and Stake (in future) library. 
*/

contract EthMLStorage{

  using SafeMath for uint256;
  using EthMLGettersLib for EthMLStorageLib.EthMLStorageStruct;
  using EthMLStorageLib for EthMLStorageLib.EthMLStorageStruct;
  using EthMLTransferLib for EthMLStorageLib.EthMLStorageStruct;
  using EthMLLib for EthMLStorageLib.EthMLStorageStruct;

  EthMLStorageLib.EthMLStorageStruct ethML;

  /**
  * @dev returns the address variables in the internal storage stored as
  * addressStorage[keccak('variableName')]
  */
  function getAddressStorage(bytes32 _data) external view returns(address) {
    return ethML.getAddressStorage(_data);
  }

  /**
  * @dev returns the uint variables in the internal storage stored as
  * uintStorage[keccak('variableName')]
  */
  function getUintStorage(bytes32 _data) external view returns(uint256) {
    return ethML.getUintStorage(_data);
  }

  
  /*ERC20 utility token helpers*/

  function balanceOf(address _owner) external view returns(uint256) {
    return ethML.balanceOf(_owner);
  }

  function allowance(address _owner, address _spender) external view returns(uint256) {
    return ethML.allowance(_owner, _spender);
  }

  function totalSupply() external view returns(uint256) {
    return ethML.totalSupply();
  }
}