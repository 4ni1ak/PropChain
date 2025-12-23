// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DepositQueue {
    struct Deposit {
        bytes32 propertyId;
        address depositor;
        bytes32 anonymousId;
        uint256 amount;
        uint256 queuePosition;
        uint256 timestamp;
        string status; // pending, accepted, rejected, withdrawn
        bool exists;
    }
    
    mapping(bytes32 => Deposit) public deposits;
    mapping(bytes32 => bytes32[]) public propertyQueues;
    
    event DepositSubmitted(bytes32 indexed depositId, bytes32 indexed propertyId, uint256 position);
    event DepositAccepted(bytes32 indexed depositId);
    event DepositRejected(bytes32 indexed depositId);
    event DepositWithdrawn(bytes32 indexed depositId);
    
    function submitDeposit(bytes32 _propertyId) public payable returns (bytes32, uint256) {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        bytes32 anonymousId = keccak256(abi.encodePacked(msg.sender, block.timestamp, "SECRET_SALT"));
        // Add queue length to ensure unique hash even for same user/block
        bytes32 depositId = keccak256(abi.encodePacked(msg.sender, _propertyId, block.timestamp, propertyQueues[_propertyId].length));
        
        uint256 position = propertyQueues[_propertyId].length + 1;
        
        deposits[depositId] = Deposit({
            propertyId: _propertyId,
            depositor: msg.sender,
            anonymousId: anonymousId,
            amount: msg.value,
            queuePosition: position,
            timestamp: block.timestamp,
            status: "pending",
            exists: true
        });
        
        propertyQueues[_propertyId].push(depositId);
        
        emit DepositSubmitted(depositId, _propertyId, position);
        return (depositId, position);
    }
    
    function acceptDeposit(bytes32 _depositId) public {
        // In a real scenario, we'd check if msg.sender is the property owner via PropertyRegistry
        require(deposits[_depositId].exists, "Deposit does not exist");
        require(keccak256(abi.encodePacked(deposits[_depositId].status)) == keccak256(abi.encodePacked("pending")), "Deposit is not pending");
        
        deposits[_depositId].status = "accepted";
        // Transfer funds to property owner (simplified logic here)
        payable(msg.sender).transfer(deposits[_depositId].amount);
        
        emit DepositAccepted(_depositId);
    }
    
    function rejectDeposit(bytes32 _depositId) public {
        require(deposits[_depositId].exists, "Deposit does not exist");
        require(keccak256(abi.encodePacked(deposits[_depositId].status)) == keccak256(abi.encodePacked("pending")), "Deposit is not pending");
        
        deposits[_depositId].status = "rejected";
        // Refund funds to depositor
        payable(deposits[_depositId].depositor).transfer(deposits[_depositId].amount);
        
        emit DepositRejected(_depositId);
    }

    function withdrawDeposit(bytes32 _depositId) public {
        require(deposits[_depositId].exists, "Deposit does not exist");
        require(deposits[_depositId].depositor == msg.sender, "Only depositor can withdraw");
        require(keccak256(abi.encodePacked(deposits[_depositId].status)) == keccak256(abi.encodePacked("pending")), "Deposit is not pending");
        
        deposits[_depositId].status = "withdrawn";
        payable(msg.sender).transfer(deposits[_depositId].amount);
        
        emit DepositWithdrawn(_depositId);
    }
    
    function getQueue(bytes32 _propertyId) public view returns (bytes32[] memory) {
        return propertyQueues[_propertyId];
    }
}
