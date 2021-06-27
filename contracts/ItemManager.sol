pragma solidity ^0.6.0;

contract ItemManager{
    
    //define 3 states of the supply chain
    enum SupplyChainState{Created, Paid, Delivered}
    
    //define Item's attributes
    struct S_Item{
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    //_step = {0: Created, 1:Paid, 2:Delivered}, SupplyChainState must be type casted to uint
    event SupplyChainStep(uint _ItemIndex, uint _step);
    
    //create an Item at a new index and notify it with an event
    function createItem(string memory _identifier, uint _itemPrice) public {
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
        itemIndex++;
        
    }
    
    //accept payment in ether from client for an item at an index, update the status of the order to Paid
    //and notify it with an event
    function triggerPayment(uint _ItemIndex) public payable {
        require(msg.value == items[_ItemIndex]._itemPrice, "Only full payments accepted");
        require(items[_ItemIndex]._state == SupplyChainState.Created, "Item is further in the Chain");
        items[_ItemIndex]._state = SupplyChainState.Paid;
        
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
    }
    
    //trigger the delivery, update the status of the order to Delivered and notify it with an event
    function triggerDelivery(uint _ItemIndex) public {
        require(items[_ItemIndex]._state == SupplyChainState.Paid, "Item is further in the Chain");
        items[_ItemIndex]._state = SupplyChainState.Delivered;
        
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
    }
}