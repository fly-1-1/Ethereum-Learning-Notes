// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

//WETH代币,包装ETH主币,作为ERC20的合约
//装换金额要匹配
/*
    deposit -10ETH => 10WETH
    withdraw -10WETH => 10ETH
WETH 需要遵守ERC20标准

3个查询
    balanceof:查询指定地址的 Token 数量
    allowance:查询指定地址对另外一个地址的剩余授权额度
    totalSupply:查询当前合约的 Token 总量
2个交易
    transfer:从当前调用者地址发送指定数量的 Token 到指定地址。
    这是一个写入方法，所以还会抛出一个 Transfer 事件。
    transferFrom:当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token拿到它自己的合约中。
2个事件
    Transfer
    Approval
- 1个授权
    approve:授权指定地址可以操作调用者的最大 Token 数量-
*/

contract WETH {
    string public constant name = "Wrapped Wther";
    string public constant Symbol = "WETH";
    uint8  public constant decimals = 18;

    // event
    event Approval(
        address indexed src,
        address indexed delegateAds,
        uint256 amount
    );
    event Transfer(address indexed src, address indexed toAds, uint256 amount);
    event Deposit(address indexed toAds, uint256 amount);
    event Withdraw(address indexed src, uint256 amount);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount_) public payable {
        require(balanceOf[msg.sender] >= amount_, "error amount");
        balanceOf[msg.sender] -= amount_;
        payable(msg.sender).transfer(amount_);
        emit Withdraw(msg.sender, msg.value);
    }

    //totalSupply:查询当前合约的 Token 总量
    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    //approve:授权指定地址可以操作调用者的最大 Token 数量-
    function approve(address delegateAds_, uint256 amount_)
        public
        returns (bool)
    {
        allowance[msg.sender][delegateAds_] = amount_;
        emit Approval(msg.sender, delegateAds_, amount_);
        return true;
    }

    // transfer:从当前调用者地址发送指定数量的 Token 到指定地址。
    function transfer(address toAds_, uint256 amount_) public returns (bool) {
        return transferFrom(msg.sender, toAds_, amount_);
    }

    //transferFrom:当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token拿到它自己的合约中。
    function transferFrom( address src,address toAds_,uint256 amount_) public returns (bool) {
        require(balanceOf[src] >= amount_, "error amount");

        if(src != msg.sender){
            require(allowance[src][toAds_] >= amount_);
            allowance[src][msg.sender] -= amount_;
        }

        balanceOf[src]-=amount_;
        balanceOf[toAds_]+=amount_;
        emit Transfer(src, toAds_, amount_);
        return true;
    }


    receive() external payable { 
        deposit();
    }
}

//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2