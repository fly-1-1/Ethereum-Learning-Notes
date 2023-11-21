// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

// 两种角色:
//      受益人   beneficiary => address         => address 类型
//      资助者   funders     => address:amount  => mapping 类型 或者 struct 类型

// 状态变量
//      筹资目标数量    fundingGoal
//      当前募集数量    fundingAmount
//      资助者列表      funders
//      资助者人数      fundersKey

contract CrowdFunding {
    address public immutable beneficiary;
    uint256 public immutable fundingGoal;

    uint256 public fundingAmount;
    mapping(address => uint256) public funders; //资助者列表

    mapping(address => bool) private fundersInserted;

    address[] public fundersKey; //资助者人数

    bool public AVAILABLE = true; //状态

    //部署的时候写入 写入受益人 部署目标数量
    constructor(address beneficiary_, uint256 goal_) {
        beneficiary = beneficiary_;
        fundingGoal = goal_;
    }

    //资助
    //      可用才可以捐款
    //      合约关闭就不可以操作
    function contribute() external payable {
        require(AVAILABLE, "CrowdFunding is closed");
        funders[msg.sender] += msg.value;
        fundingAmount += msg.value;
        if (!fundersInserted[msg.sender]) {
            fundersInserted[msg.sender] = true;
            fundersKey.push(msg.sender);
        }
    }

    //关闭
    function close() external returns (bool) {
        if (fundingGoal > fundingAmount) {
            return false;
        }
        uint256 amount = fundingAmount;

        //修改
        fundingAmount = 0;
        AVAILABLE =false;

        //操作
        payable (beneficiary).transfer(amount);
        return true;
    }

    function fundersLenght() public view returns(uint256){
        return fundersKey.length;
    }
}
