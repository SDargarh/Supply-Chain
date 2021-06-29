pragma solidity ^0.6.0;

import "./Item.sol";
import "./Ownable.sol";

contract ItemManager is Ownable{
    
    //define 3 states of the supply chain
    enum SupplyChainState{Created, Paid, Delivered}
    
    //define Item's attributes
    struct S_Item{
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    //_step = {0: Created, 1:Paid, 2:Delivered}, SupplyChainState must be type casted to uint
    event SupplyChainStep(uint _itemIndex, uint _step, address _address);
    
    //create an Item at a new index and notify it with an event
    //adding a check to ensure only owner can call this function
    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner {
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
        
    }
    
    //accept payment in ether from client for an item at an index, update the status of the order to Paid
    //and notify it with an event
    function triggerPayment(uint _itemIndex) public payable {
        Item item = items[_itemIndex]._item;
        require(address(item) == msg.sender, "Only items are allowed to update themselves");
        require(msg.value == items[_itemIndex]._itemPrice, "Only full payments accepted");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the Chain");
        items[_itemIndex]._state = SupplyChainState.Paid;
        
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
    
    //trigger the delivery, update the status of the order to Delivered and notify it with an event
    //adding a check to ensure only owner can call this function
    function triggerDelivery(uint _itemIndex) public onlyOwner {
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item is further in the Chain");
        items[_itemIndex]._state = SupplyChainState.Delivered;
        
        emit SupplyChainStep(itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
}