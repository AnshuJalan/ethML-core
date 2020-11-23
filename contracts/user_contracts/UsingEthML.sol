pragma solidity ^0.5.0;

/**
* @dev Contract to be extended to get the EthML functionalties.
* This has functions to make relevant request calls to the proxy,
* and receive predictions.
*/
contract UsingEthML {

  address owner;
  address public implAddress;

  mapping(uint256 => bool) pendingRequests;
  mapping(uint256 => uint256) responses;

  uint256 latestResponseId;

  event NewRequest(uint256 modelId, string dataPoint, uint256 tip, uint256 requestId);
  event ReceivedPrediction(uint256 requestId, uint256 prediction);
  event EthMLContractChanged(address newAddress);

  constructor(address _implAddress) public {
    owner = msg.sender;
    implAddress = _implAddress;
  }

  /**
  * @notice Change to internal
  * @dev sends prediction request to proxy.
  */
  function requestPrediction(uint256 _modelId, string calldata _dataPoint, uint256 _tip) external {
    address _impl = implAddress;
    bytes memory _calldata = abi.encodeWithSignature('requestPrediction(uint256,string,uint256)', _modelId, _dataPoint, _tip);
    uint256 _id;

    assembly {
      let ptr := mload(0x40)
      let result := call(gas, _impl, 0, add(_calldata, 32), mload(_calldata), 0, 0)
      returndatacopy(ptr, 0, returndatasize)
      _id := mload(ptr)
    }

    pendingRequests[_id] = true;
    emit NewRequest(_modelId, _dataPoint, _tip, _id);
  }

  /**
  * @dev callback function to allow EthML serve the requested prediction 
  * to the user contract.
  */
  function requestCallback(uint256 _id, uint256 _prediction) external isValidCall(_id){
    latestResponseId = _id;
    delete pendingRequests[_id];
    responses[_id] = _prediction;

    emit ReceivedPrediction(_id, _prediction);
  }

  /**
  * @dev view function to allow the user to retrieve the prediction value 
  */
  function getLatestResponse() external view returns(uint256) {
    return responses[latestResponseId];
  }

  modifier isValidCall(uint256 _id) {
    require(pendingRequests[_id], "Invalid request id!");
    require(msg.sender == implAddress, "Not authorized!");
    _;
  }
}