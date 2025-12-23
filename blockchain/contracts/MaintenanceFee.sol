// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MaintenanceFee {
    struct Payment {
        bytes32 buildingId;
        string apartmentNo;
        address tenant;
        string month; // YYYY-MM
        uint256 amount;
        uint256 paymentDate;
        bool isPaid;
        bool exists;
    }
    
    mapping(bytes32 => Payment) public payments;
    mapping(bytes32 => mapping(string => bytes32[])) public buildingPayments; // buildingId -> month -> paymentIds
    mapping(bytes32 => uint256) public monthlyFees; // buildingId -> fee
    mapping(bytes32 => address) public buildingManagers; // buildingId -> manager address
    
    event FeeSet(bytes32 indexed buildingId, uint256 amount);
    event FeePaid(bytes32 indexed paymentId, bytes32 indexed buildingId, string month);
    
    function setMonthlyFee(bytes32 _buildingId, uint256 _amount) public {
        // Ideally restricted to manager
        monthlyFees[_buildingId] = _amount;
        buildingManagers[_buildingId] = msg.sender; // Set the sender as the manager
        emit FeeSet(_buildingId, _amount);
    }
    
    function payFee(bytes32 _buildingId, string memory _apartmentNo, string memory _month) public payable {
        require(msg.value >= monthlyFees[_buildingId], "Insufficient fee amount");
        
        bytes32 paymentId = keccak256(abi.encodePacked(_buildingId, _apartmentNo, _month));
        require(!payments[paymentId].isPaid, "Fee already paid for this month");

        payments[paymentId] = Payment({
            buildingId: _buildingId,
            apartmentNo: _apartmentNo,
            tenant: msg.sender,
            month: _month,
            amount: msg.value,
            paymentDate: block.timestamp,
            isPaid: true,
            exists: true
        });
        
        buildingPayments[_buildingId][_month].push(paymentId);
        
        // Transfer fee to the building manager
        address manager = buildingManagers[_buildingId];
        if (manager != address(0)) {
            payable(manager).transfer(msg.value);
        }
        
        emit FeePaid(paymentId, _buildingId, _month);
    }
    
    function getPayment(bytes32 _paymentId) public view returns (Payment memory) {
        return payments[_paymentId];
    }

    function getBuildingPayments(bytes32 _buildingId, string memory _month) public view returns (bytes32[] memory) {
        return buildingPayments[_buildingId][_month];
    }
}
