pragma solidity ^0.5.0;

import './SafeMath.sol';
import './EthMLStorageLib.sol';

/**
* @dev logic for the getter functions present in EthMLStorage contract
*/
library EthMLGettersLib {
  using SafeMath for uint256;

  function getAddressStorage(EthMLStorageLib.EthMLStorageStruct storage self, bytes32 _data) internal view returns(address){
      return self.addressStorage[_data];
  }

  function getUintStorage(EthMLStorageLib.EthMLStorageStruct storage self, bytes32 _data) internal view returns(uint){
      return self.uintStorage[_data];
  }

  function getCurrentVariables(EthMLStorageLib.EthMLStorageStruct storage self) internal view returns(
    bytes32, uint256, uint256, uint256, string memory
  ) {
    return (
      self.currentChallenge,
      self.uintStorage[keccak256('currentRequestId')],
      self.uintStorage[keccak256('diffculty')],
      self.requestIdToRequest[self.uintStorage[keccak256('currentRequestId')]].modelId,
      self.requestIdToRequest[self.uintStorage[keccak256('currentRequestId')]].dataPoint
    );
  }

  function canGetVariables(EthMLStorageLib.EthMLStorageStruct storage self) internal view returns(bool) {
    return self.uintStorage[keccak256('currentRequestId')] != 0;
  }

  function totalSupply(EthMLStorageLib.EthMLStorageStruct storage self) internal view returns(uint256) {
    return self.uintStorage[keccak256('totalSupply')];
  }
}