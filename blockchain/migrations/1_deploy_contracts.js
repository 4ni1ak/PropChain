const PropertyRegistry = artifacts.require("PropertyRegistry");
const DepositQueue = artifacts.require("DepositQueue");
const MaintenanceFee = artifacts.require("MaintenanceFee");
const RentPayment = artifacts.require("RentPayment");

module.exports = function (deployer) {
  deployer.deploy(PropertyRegistry);
  deployer.deploy(DepositQueue);
  deployer.deploy(MaintenanceFee);
  deployer.deploy(RentPayment);
};
