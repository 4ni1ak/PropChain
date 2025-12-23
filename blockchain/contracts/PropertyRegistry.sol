// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyRegistry {
    struct Property {
        address owner;
        string propertyType;
        string location;
        uint256 price;
        uint256 maintenanceFee;
        string status; // available, pending, rented, sold
        uint256 timestamp;
        bool exists;
    }
    
    mapping(bytes32 => Property) public properties;
    mapping(address => bytes32[]) public ownerProperties;
    bytes32[] public allPropertyIds;
    
    event PropertyRegistered(bytes32 indexed propertyId, address indexed owner);
    event PropertyStatusChanged(bytes32 indexed propertyId, string newStatus);
    
    function registerProperty(
        string memory _propertyType,
        string memory _location,
        uint256 _price,
        uint256 _maintenanceFee
    ) public returns (bytes32) {
        bytes32 propertyId = keccak256(abi.encodePacked(msg.sender, _location, block.timestamp));
        
        properties[propertyId] = Property({
            owner: msg.sender,
            propertyType: _propertyType,
            location: _location,
            price: _price,
            maintenanceFee: _maintenanceFee,
            status: "available",
            timestamp: block.timestamp,
            exists: true
        });
        
        ownerProperties[msg.sender].push(propertyId);
        allPropertyIds.push(propertyId);
        
        emit PropertyRegistered(propertyId, msg.sender);
        return propertyId;
    }
    
    function updatePropertyStatus(bytes32 _propertyId, string memory _newStatus) public {
        require(properties[_propertyId].exists, "Property does not exist");
        require(properties[_propertyId].owner == msg.sender, "Only owner can update status");
        
        properties[_propertyId].status = _newStatus;
        emit PropertyStatusChanged(_propertyId, _newStatus);
    }
    
    function getProperty(bytes32 _propertyId) public view returns (Property memory) {
        require(properties[_propertyId].exists, "Property does not exist");
        return properties[_propertyId];
    }

    function getAllPropertyIds() public view returns (bytes32[] memory) {
        return allPropertyIds;
    }

    function getOwnerProperties(address _owner) public view returns (bytes32[] memory) {
        return ownerProperties[_owner];
    }

    function buyProperty(bytes32 _propertyId) public payable {
        require(properties[_propertyId].exists, "Property does not exist");
        require(properties[_propertyId].price > 0, "Property not for sale");
        require(msg.value >= properties[_propertyId].price, "Insufficient funds");
        require(properties[_propertyId].owner != msg.sender, "Cannot buy own property");
        
        address previousOwner = properties[_propertyId].owner;
        
        // Transfer ownership
        properties[_propertyId].owner = msg.sender;
        properties[_propertyId].status = "sold";
        
        // Add to new owner's list
        ownerProperties[msg.sender].push(_propertyId);
        
        // Transfer funds to previous owner
        payable(previousOwner).transfer(msg.value);
        
        emit PropertyStatusChanged(_propertyId, "sold");
        emit PropertyRegistered(_propertyId, msg.sender); // Emit ownership change
    }
}
