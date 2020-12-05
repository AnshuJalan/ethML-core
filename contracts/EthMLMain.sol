pragma solidity ^0.5.0;

import './EthMLStorage.sol';

/** 
* @title EthML Main
* @dev Proxy contract to make delegate calls to the latest implementation
*/
contract EthMLMain is EthMLStorage{

  constructor(address _implAddress) public {
    //Todo: Call init()

    ethML.initTest();
    ethML.addressStorage[keccak256('ethMLAddress')] = _implAddress;
    ethML.addressStorage[keccak256('owner')] = msg.sender;
  }

  //Events for testing (remove later)
  event NewBlock(uint256 id, uint256 prediction, uint256 nonce);

  /**
  * @dev Allows for implementation contract upgrades
  */
  function updateImplementation(address _newImpl) external {
    ethML.updateImplementation(_newImpl);
  }

  /**
  * @dev sets the new owner
  */
  function setOwner(address _newOwner) external {
    ethML.setOwner(_newOwner);
  }

  function() external payable {
    address _impl = ethML.addressStorage[keccak256('ethMLAddress')];

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