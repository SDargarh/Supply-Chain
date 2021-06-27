pragma solidity ^0.6.0;

import "./ItemManager.sol";

contract Item{
    ItemManager parentContract;
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    
    //initialize the item
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public{
        parentContract = _parentContract;
        priceInWei = _priceInWei;
        index = _index;
    }
    
    //send back the money to ItemManager
    receive() external payable{
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payments accepted");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "The transaction wasn't successful, canceling");
        
        //to check if item was paid already
    }
    
    fallback() external {}
}
