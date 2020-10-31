pragma solidity ^0.5.0;

/**
* @dev Library to define the storage type for Eternal Storage Pattern
*/

contract EthMLStorageLib{

  struct Error {
    uint256 errorType; //0: Invalid datapoint, 1: invalid request hash (No such dataset/model)
    bool hasError;
  }

  struct Request {
    bytes32 requestHash; //keccakHash(abi.encodePacked(dataset, model))

    string datapointIpfs;

    uint256 requestId;
    uint256 requestType; //0: Classification, 1: Regression
    uint256 predictionsReceived; //newBlock on 5th prediction
    uint256[5] finalValues;
    
    Error error;

    mapping(uint256 => address[5]) valueToMiners;
    
    //keccak256("birth") - required for request aging
    //keccak256("tip")
    mapping(bytes32 => uint256) requestUintStorage;
  }

  struct EthMLStorageStruct{
    mapping(bytes32 => uint) uintStorage;
    mapping(bytes32 => address) addressStorage;

    bytes32 currentChallenge;

    uint256[5] requestQ;

    mapping(uint256 => Request) requestIdtoRequest;
    //Token Vars
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowance;
  }
}