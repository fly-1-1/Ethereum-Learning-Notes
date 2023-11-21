 // SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract ETH {
    address payable public immutable owner;
    event Log(string funName, address from, uint256 value, bytes data);

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    function withdraw1() external payable {
        require(msg.sender==owner,"not owner");
        payable (msg.sender).transfer(10);

    }

    function withdraw2() external payable {
        require(msg.sender==owner,"not owner");
        bool success = payable (msg.sender).send(20);
        require(success,"Send Failed");
    }

    function withdraw3() external {
        require(msg.sender==owner,"not owner");
       (bool success,) = msg.sender.call{value:address(this).balance}("");
        require(success,"Send Failed");
        
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
