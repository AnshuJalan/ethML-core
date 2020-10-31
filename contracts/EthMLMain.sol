pragma solidity ^0.5.0;

import './EthMLStorage.sol';

/** 
* @title EthML Main
* @dev Proxy contract to make delegate calls to the latest implementation
*/
contract EthMLMain is EthMLStorage{

  function() external payable {
    address _impl;

    assembly {
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize)
      let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
      let size := returndatasize
      returndatacopy(ptr, 0, size)

      switch result
      case 0 { revert(ptr, size) }
      default { return(ptr, size) }
    }
  }
}