// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract Demo {
    /// @notice    标记当前进度的
    /// @dev       0:等待领导说"同志们好"
    /// @dev       1:等待同志们回复"领导好"
    /// @dev       2:等待领导说"同志们辛苦了"
    /// @dev       3:等待同志们回复"为人名服务"
    /// @dev       4:等待销毁合约
    /// @return    5:当前进度
    uint8 public step = 0;

    address public immutable leader;

    string internal constant UNKOWN = unicode"i dont't kown";

    /// @notice         用于当前step被修改的同志
    /// @dev            只要step发生变化,都抛出事件
    //  @param          当前最新的step
    event Step(uint8);

    constructor(address leader_) {
        require(leader_ != address(0), "invalid address");
        leader = leader_;
    }

    /// @notice         检查只能领导调用
    /// @dev            用于领导使用的函数
    modifier OnlyLeader() {
        require(msg.sender == leader, unicode"必须领导才能说");
        _;
    }

    /// @notice         检查只能非领导调用
    /// @dev            用于同志们使用的函数
    modifier NoteLeader() {
        require(msg.sender != leader, unicode"领导不能说");
        _;
    }

    /// @notice 自定义错误
    /// @dev    所有已知错误
    /// @param 错误信息

    /// 这是一个自定义错误
    error MyError(string msg);

    /// @notice      用于领导说"同志们好"
    /// @dev         只能在step为0的时候调用,只能领导调用,并且只能领导说"同志们好"
    /// @param content: 当前领导说的内容
    /// @return      当前调用状态 true为成功
    function hello(string calldata content) external OnlyLeader returns (bool) {
        if (step != 0) {
            revert(UNKOWN);
        }

        if (!review(content, unicode"同志们好")) {
            revert MyError(unicode"必须说:同志们好");
        }

        step = 1;
        emit Step(step);
        return true;
    }

    /// @notice      用于同志们说"领导好"
    /// @dev           只能在step为1的时候调用,只能同志们调用,并且只能同志们说"领导好"
    /// @param content: 当前同志们说的内容
    /// @return      当前调用状态 true为成功
    function helloRes(string calldata content)
        external
        NoteLeader
        returns (bool)
    {
        if (step != 1) {
            revert(UNKOWN);
        }

        if (!review(content, unicode"领导好")) {
            revert MyError(unicode"必须说:领导好");
        }

        step = 2;
        emit Step(step);
        return true;
    }

    /// @notice      用于领导说"同志们辛苦了"
    /// @dev         只能在step为2的时候调用,只能领导调用,并且只能领导说"同志们辛苦了"
    /// @param content: 当前领导说的内容
    /// @return      当前调用状态 true为成功
    function comfort(string calldata content)
        external
        payable
        OnlyLeader
        returns (bool)
    {
        if (step != 2) {
            revert(UNKOWN);
        }

        if (!review(content, unicode"同志们辛苦了")) {
            revert MyError(unicode"必须说:同志们辛苦了");
        }

        if (msg.value < 2 ether) {
            revert MyError(unicode"至少两个以太币");
        }

        step = 3;
        emit Step(step);
        emit Log("comfort", msg.sender, msg.value, msg.data);
        return true;
    }

    /// @notice      用于同志们说"为人民服务"
    /// @dev           只能在step为1的时候调用,只能同志们调用,并且只能同志们说"为人民服务"
    /// @param content: 当前同志们说的内容
    /// @return      当前调用状态 true为成功
    function comfortRes(string calldata content)
        external
        NoteLeader
        returns (bool)
    {
        if (step != 3) {
            revert(UNKOWN);
        }

        if (!review(content, unicode"为人民服务")) {
            revert MyError(unicode"必须说:为人民服务");
        }

        step = 4;
        emit Step(step);
        return true;
    }

    /// @notice 用于领导对合约销毁
    /// @dev    是能step为4的时候调用 只能领导调用
    /// @return 当前调用状态
    function destruct() external OnlyLeader returns (bool) {
        if (step != 4) {
            revert(UNKOWN);
        }

        emit Log("destruct", msg.sender, address(this).balance, msg.data);
        selfdestruct(payable(msg.sender));
        return true;
    }

    function review(string calldata content, string memory correctContent)
        internal
        pure
        returns (bool)
    {
        return
            keccak256(abi.encodePacked(content)) ==
            keccak256(abi.encodePacked(correctContent));
    }

    /// @notice         金额变动的通知
    /// @dev            只要合约金额发生变化,都抛出事件
    ///  @param tag      标记内容
    ///  @param from     当前地址
    ///  @param value    当前发送余额
    ///  @param data     当前调用data内容
    event Log(string tag, address from, uint256 value, bytes data);

    receive() external payable {
        emit Log("recive", msg.sender, msg.value, "");
    }

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    /// @notice       用来获取当前合约的余额
    /// @dev          获取当前余额的辅助函数
    /// @return       当前合约的余额
    function getbalance() public view returns (uint256) {
        return address(this).balance;
    }
}
