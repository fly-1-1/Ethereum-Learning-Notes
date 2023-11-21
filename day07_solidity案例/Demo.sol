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



    /// @notice 用于辅助获取下一步该做什么的方法
    /// @dev 整理step对应的错误，注意数字转为字符串时候的途径
    /// @return 当前的提示信息
    function helperInfo() external view returns (string memory) {
        string memory stepDes = unicode"当前的step是:";
        string memory info;

        if (step == 0) {
            info = unicode"可以执行 hello ,领导说:同志们好";
        } else if (step == 1) {
            info = unicode"可以执行 helloRes ,同志们说:领导好";
        } else if (step == 2) {
            info = unicode"可以执行 comfort ,领导必须给钱，并且说:同志们辛苦了";
        } else if (step == 3) {
            info = unicode"可以执行 comfortRes ,同志们说:为人民服务";
        } else if (step == 4) {
            info = unicode"可以执行 selfdestruct";
        } else {
            info = unicode"未知";
        }

        return string.concat(stepDes, uintToString(step), " ", info);
    }

    // 另外一种转换方法
    //调用这个函数，通过取模的方式，一位一位转换
    function uintToString(uint256 _uint)
        internal
        pure
        returns (string memory str)
    {
        if (_uint == 0) return "0";
        while (_uint != 0) {
            //取模
            uint256 remainder = _uint % 10;
            //每取一位就移动一位，个位、十位、百位、千位……
            _uint = _uint / 10;
            //将字符拼接，注意字符位置
            str =  string.concat(toStr(remainder), str);
        }
    }

    function toStr(uint256 num_) internal pure returns (string memory) {
        require(num_ < 10,"error");
        bytes memory alphabet = "0123456789";
        bytes memory str = new bytes(1);
        str[0] = alphabet[num_];
        return string(str);
    }
}
