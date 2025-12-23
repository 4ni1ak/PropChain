const DepositQueue = artifacts.require("DepositQueue");
const PropertyRegistry = artifacts.require("PropertyRegistry");

contract("PropChain System", (accounts) => {
  let depositQueue;
  let propertyRegistry;
  const owner = accounts[0];
  const user1 = accounts[1];
  const user2 = accounts[2];

  before(async () => {
    depositQueue = await DepositQueue.deployed();
    propertyRegistry = await PropertyRegistry.deployed();
  });

  it("should register a property", async () => {
    const tx = await propertyRegistry.registerProperty(
      "Apartment",
      "Ankara-Cankaya-MainSt-10",
      web3.utils.toWei("1", "ether"),
      web3.utils.toWei("0.1", "ether"),
      { from: owner }
    );

    const event = tx.logs[0];
    assert.equal(event.event, "PropertyRegistered", "PropertyRegistered event should be emitted");
    assert.equal(event.args.owner, owner, "Owner should be correct");
  });

  it("should submit a deposit and assign correct queue position", async () => {
    // Generate a mock property ID (hash)
    const propertyId = web3.utils.keccak256("property1");

    // User 1 deposits
    const tx1 = await depositQueue.submitDeposit(propertyId, {
      from: user1,
      value: web3.utils.toWei("1", "ether")
    });

    assert.equal(tx1.logs[0].event, "DepositSubmitted");
    assert.equal(tx1.logs[0].args.position.toString(), "1", "First deposit should be position 1");

    // User 2 deposits
    const tx2 = await depositQueue.submitDeposit(propertyId, {
      from: user2,
      value: web3.utils.toWei("1", "ether")
    });

    assert.equal(tx2.logs[0].args.position.toString(), "2", "Second deposit should be position 2");
  });

  it("should retrieve queue correctly", async () => {
    const propertyId = web3.utils.keccak256("property1");
    const queue = await depositQueue.getQueue(propertyId);
    
    assert.equal(queue.length, 2, "Queue should have 2 deposits");
  });
});
