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
}