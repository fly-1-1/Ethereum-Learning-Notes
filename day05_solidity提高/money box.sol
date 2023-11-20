// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;


//多次存,一次取,取完就销毁
contract Bank{
    address public immutable owner;


    event Deposit(address _ads,uint256 amount);

    event WithDraw(uint256 amount);

    receive() external payable { 
       deposit();
    }

    constructor(){
        //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        owner=msg.sender;
    }


    function withdraw() external {
        require(msg.sender == owner,"Not owner address");
        emit  WithDraw(address(this).balance);
        selfdestruct(payable (msg.sender));
    }

    function deposit() public  payable  {
        emit  Deposit(msg.sender,msg.value);
    }

    function getBalance() external view returns (uint256){
        return address(this).balance;
    }

}