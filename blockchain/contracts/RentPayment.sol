// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RentPayment {
    struct RentRecord {
        bytes32 propertyId;
        address tenant;
        address owner;
        string month;
        uint256 amount;
        uint256 paymentDate;
        bool isPaid;
        bool exists;
    }
    
    mapping(bytes32 => RentRecord) public rentRecords;
    mapping(address => bytes32[]) public tenantHistory;
    mapping(bytes32 => bytes32[]) public propertyRentHistory;
    
    event RentPaid(bytes32 indexed recordId, bytes32 indexed propertyId, string month, uint256 amount);
    
    function payRent(bytes32 _propertyId, address _owner, string memory _month) public payable {
        require(msg.value > 0, "Rent amount must be greater than 0");
        
        bytes32 recordId = keccak256(abi.encodePacked(_propertyId, _month, msg.sender));
        require(!rentRecords[recordId].isPaid, "Rent already paid for this month");

        rentRecords[recordId] = RentRecord({
            propertyId: _propertyId,
            tenant: msg.sender,
            owner: _owner,
            month: _month,
            amount: msg.value,
            paymentDate: block.timestamp,
            isPaid: true,
            exists: true
        });
        
        tenantHistory[msg.sender].push(recordId);
        propertyRentHistory[_propertyId].push(recordId);
        
        // Transfer rent to owner
        payable(_owner).transfer(msg.value);
        
        emit RentPaid(recordId, _propertyId, _month, msg.value);
    }
    
    function getTenantHistory(address _tenant) public view returns (bytes32[] memory) {
        return tenantHistory[_tenant];
    }

    function getPropertyRentHistory(bytes32 _propertyId) public view returns (bytes32[] memory) {
        return propertyRentHistory[_propertyId];
    }

    function getRentRecord(bytes32 _recordId) public view returns (RentRecord memory) {
        return rentRecords[_recordId];
    }
}
