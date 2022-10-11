//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract FillingStation {

    //address of the contract owner
    address public owner;
    //gas balances of each contract address.
    mapping(address => uint) public gasBalances;


    event stockUpdated(uint _gasBlance,address _owner);

    constructor() {
        owner = msg.sender;
        //At the start of the contract, the gas balance of the station is 1000.
        gasBalances[address(this)] = 1000;
    }

    //Find out the gas amount.
    function getStationGasBalance() public view returns(uint) {
        return gasBalances[address(this)];
    }
    
    //Updates the stock of station gas balance.
    function restock(uint amount) checkSender() public {
        gasBalances[address(this)] += amount; 
        emit stockUpdated(gasBalances[address(this)], msg.sender);
    }

    
    function purchase(uint amount) checkGasBlance(amount) public payable{
        //Gas price is .10 ether for each liter.
        require(msg.value >= amount * 0.10 ether,"You must pay 0.10 ether per liter");
        gasBalances[address(this)] -= amount;
        gasBalances[msg.sender] += amount;
    }

    modifier checkSender() {
        require(msg.sender == owner, "Only the owner can restock.");
        _;
    }
    modifier checkGasBlance(uint _amount) {
        require(gasBalances[address(this)] >= _amount, "Not enough gas in stock to complate this purchase");
        _;
    }
} 
