// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract Auction{

    // define structure for bidding item
    struct item {
        string item_name;
        uint256 price; 
        address  highest_bidder;
    }
    
    // create an instance of the bidding item structure
    item  biddingItem;
    
    // save the owner of the contract address
    address payable owner;
    
    // save winner address
    address  public winner;
    
    // save currentBids for each participant
    mapping(address => uint256)  public currentBids;
    
  
    // called once contract is deployed  
    constructor(){
        // setting contract owner
        owner = payable(msg.sender);
        
        // set Auction data
        biddingItem.item_name = "Porsche 918 spyder";
        
        // setting starting price 
        biddingItem.price = 2 ether;
        
        
    }
    
    modifier onlyOwner(){
        require(msg.sender== owner);
        _;
    }
    
    modifier winnerNotSet(){
        require(winner ==address(0));
        _;
    }
    
    // sender add to his current bid price
    // the total amount in his account should be > highest_bid
    function bid() public payable winnerNotSet{
        // require winner is not set and  money transfer
        require(msg.value > 0);
        
        // add the transfered value to the senders bidding price
        // add old value to new value 
        uint newVal = currentBids[msg.sender] + msg.value;
        // require the total bid become the new highest bid
        require(newVal> biddingItem.price);
        
        // update item price, highest_bidder, and the senders account
        biddingItem.price = msg.value;
        biddingItem.highest_bidder = msg.sender;
        currentBids[msg.sender] = newVal;
    }
    
    
    // function where auction losers can withdraw there money back
    //PULL PAYMENT PATTERN
    function withdraw() public  {
        
        // check the senders account and make sure he is not the highest_bidder
        require(msg.sender!= biddingItem.highest_bidder && currentBids[msg.sender]>0);
        
        // reset the senders account 
        uint balance = currentBids[msg.sender];
        currentBids[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }
    
    // transfer the highest bid to owner and set winner 
    function endAuction() public onlyOwner winnerNotSet{
        require(biddingItem.highest_bidder !=address(0));
        winner = biddingItem.highest_bidder;
        owner.transfer(biddingItem.price);
    }
}
