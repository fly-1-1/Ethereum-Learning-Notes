// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

/*
    部署时候传入地址参数和需要的签名数
    多个 owner 地址
    发起交易的最低签名数
    有接受 ETH 主币的方法，
    除了存款外，其他所有方法都需要 owner 地址才可以触发
    发送前需要检测是否获得了足够的签名数
    使用发出的交易数量值作为签名的凭据 ID（类似上么）
    每次修改状态变量都需要抛出事件
    允许批准的交易，在没有真正执行前取消。
    足够数量的 approve 后，才允许真正执行。
    ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]
    
    
*/

contract MultiSigWallet{

     // 状态变量
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public required;    //最小数量的值

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool exected;
    }
    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public approved;

    // 事件
    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 indexed txId);
    event Approve(address indexed owner, uint256 indexed txId);
    event Revoke(address indexed owner, uint256 indexed txId);
    event Execute(uint256 indexed txId);

    // receive
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // 函数修改器
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }
    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "tx doesn't exist");
        _;
    }
    modifier notApproved(uint256 _txId) {
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }
    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].exected, "tx is exected");
        _;
    }

    // 构造函数
    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "owner required");
        require(
            _required > 0 && _required <= _owners.length,
            "invalid required number of owners"
        );

        for (uint256 index = 0; index < _owners.length; index++) {
            address owner = _owners[index];
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is not unique"); // 如果重复会抛出错误
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }

    // 函数
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function submit(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyOwner returns(uint256){
        transactions.push(
            Transaction({to: _to, value: _value, data: _data, exected: false})
        );
        emit Submit(transactions.length - 1);
        return transactions.length - 1;
    }

    function approv(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notApproved(_txId)
        notExecuted(_txId)
    {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function execute(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        require(getApprovalCount(_txId) >= required, "approvals < required");

        Transaction storage transaction = transactions[_txId];
        transaction.exected = true;

        (bool sucess, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(sucess, "tx failed");
        emit Execute(_txId);
    }

    function getApprovalCount(uint256 _txId)
        public
        view
        returns (uint256 count)
    {
        for (uint256 index = 0; index < owners.length; index++) {
            if (approved[_txId][owners[index]]) {
                count += 1;
            }
        }
    }

    function revoke(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}