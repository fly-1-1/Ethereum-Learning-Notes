// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract ToDoList {
    struct Todo {
        string name;
        bool isCompleted;
    }

    Todo[] public list;

    //创建任务
    function create(string memory name_) external {
        list.push(Todo({name: name_, isCompleted: false}));
    }

    //修改任务名称
    function nodoName1(uint256 index_, string memory name_) external {
        list[index_].name = name_;
    }

    function nodoName2(uint256 index_, string memory name_) external {
        Todo storage temp = list[index_];
        temp.name = name_;
    }

    //修改完成状态 手动指定完成或者未完成
    function modiStatus1(uint256 index_, bool status_) external {
        list[index_].isCompleted = status_;
    }

  
    //修改完成状态 自动切换 toggle
      function modiStatus2(uint256 index_) external {
        list[index_].isCompleted = !list[index_].isCompleted;
    }

    //获取任务 memory 2次拷贝 8300gas
    function get1(uint256 index_)external view  returns(string memory name_,bool status_) {
        Todo memory temp  = list[index_];
        return (temp.name,temp.isCompleted);
    }

    // storage 1次拷贝      8100gas
        function get2(uint256 index_)external view  returns(string memory name_,bool status_) {
        Todo storage temp  = list[index_];
        return (temp.name,temp.isCompleted);
    }
}
