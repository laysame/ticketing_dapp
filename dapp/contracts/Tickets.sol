// SPDX-License-Identifier: GPL-3.0
pragma abicoder v2;
pragma solidity ^0.8.0;

uint256 constant TOTAL_TICKETS = 10; 

contract Tickets {
    address public owner = msg.sender;

    struct Ticket {
        uint256 price;
        address owner;
    }

    Ticket[TOTAL_TICKETS] public tickets;
    
    // Every ticket has a price and a owner
    constructor () payable {
        for(uint256 i = 0; i < TOTAL_TICKETS; i++) {
            tickets[i].price = 1e17; // 0.1 ETH
            tickets[i].owner = address(0x0);
        }
    }

    function buyTicket(uint256 _index) external payable {
        require(_index < TOTAL_TICKETS && _index >=0);
        require(tickets[_index].owner == address(0x0));
        require(msg.value >= tickets[_index].price);

        // Ensure that the sent value covers both the ticket price and gas cost
        uint256 gasCost = gasleft() * tx.gasprice;
        require(msg.value >= tickets[_index].price + gasCost);

        tickets[_index].owner = msg.sender;

        // Refund any excess amount
        uint256 excessAmount = msg.value - tickets[_index].price - gasCost;

        if (excessAmount > 0) {
            payable(msg.sender).transfer(excessAmount);
        }
    }

    function getTicketOwner(uint256 _index) external view returns (address) {
        require(_index < TOTAL_TICKETS && _index >= 0);
        return tickets[_index].owner;
    }
}