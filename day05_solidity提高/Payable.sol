// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    function fn1() external    view returns (address) {
        return address(this); //当前合约的地址
    }

    function fn2() external    view returns (address){
        //this 代表当前合约
        return this.fn1();
    }
}


contract Lottery1 {
   address public owner1;//0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B 合约地址
   address public owner2;//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 创建者地址
   address public owner3;           //合约调用者地址


    constructor(){
        owner1=address(this);
        owner2=msg.sender;
    }

    function fn()  public  view returns(address){
        return msg.sender;
    }
}

contract Hello {
    string public message = "hello world";
}

contract Demo {
    function name() public pure returns (string memory) {
        return type(Hello).name;
    }
    function creationCode() public pure returns (bytes memory) {
        return type(Hello).creationCode;
    }
    function runtimeCode() public pure returns (bytes memory) {
        return type(Hello).runtimeCode;
    }
}

















contract Payable {
    //payable标记函数
    function deposit1() external payable {}

    function deposit2() external {}

    //payable标记地址
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    //通过balance属性查看余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract Payable2 {
    event Log(string funName, address from, uint256 value, bytes data);

    function deposit() external payable {}

    //通过balance属性查看余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }
}

contract Fallback {
    bytes public inputData1;
    bytes public inputData2;

    fallback(bytes calldata input) external returns (bytes memory output) {
        inputData1 = input;
        inputData2 = msg.data;
        return input;
    }
}

contract Kill {
    uint256 public aaa = 123;

    constructor() payable {}

    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function bbb() external pure returns (uint256) {
        return 1;
    }

    fallback() external {}

    receive() external payable {}
}

contract Helper {
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function Kill(Kill _kill) external {
        _kill.kill();
    }
}
