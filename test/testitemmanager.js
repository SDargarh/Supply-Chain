const ItemManager = artifacts.require("/itemManager.sol");

contract("ItemManager", accounts => {
    it("add an item", async () => {
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = "test1";
        const itemPrice = 500;

        const result = await itemManagerInstance.createItem(itemName, itemPrice, { from: accounts[0] });
        assert.equal(result.logs[0].args._itemIndex, 0, "There should be one item index in there")
        const item = await itemManagerInstance.items(0);
        assert.equal(item._identifier, itemName, "The item has a different identifier");
    });
});