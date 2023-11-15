# 一 函数

## 1.pure,view and gas fee	

包含 `pure` 和 `view` 关键字的函数是不改写链上状态的，因此用户直接调用它们是不需要付 gas 的（注意，合约中非 `pure`/`view` 函数调用 `pure`/`view` 函数时需要付gas）。

在以太坊中，以下语句被视为修改链上状态：

1. 写入状态变量。
2. 释放事件。
3. 创建其他合约。
4. 使用 `selfdestruct`。
5. 通过调用发送以太币。
6. 调用任何未标记 `view` 或 `pure` 的函数。
7. 使用低级调用（low-level calls）。
8. 使用包含某些操作码的内联汇编。

## 2.internael & external

```json
// internal: 内部函数
function minus() internal {
    number = number - 1;
}

// 合约内的函数可以调用内部函数
function minusCall() external {
    minus();
}
```

## 3.payable

```j&#39;son
// payable: 递钱，能给合约支付eth的函数
function minusPayable() external payable returns(uint256 balance) {
    minus();    
    balance = address(this).balance;
}
```

​	向合约转钱,需要调用匿名函数,可以为空实现

# 二 return&returns

## 1.区别

- `returns`：跟在函数名后面，用于声明返回的变量类型及变量名。
- `return`：用于函数主体中，返回指定的变量。

```j&#39;son
// 返回多个变量
function returnMultiple() public pure returns(uint256, bool, uint256[3] memory){
    return(1, true, [uint256(1),2,5]);
}
```

## 2.命名式返回

我们可以在 `returns` 中标明返回变量的名称。Solidity 会初始化这些变量，并且自动返回这些函数的值，无需使用 `return`。

```
// 命名式返回
function returnNamed() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array){
    _number = 2;
    _bool = false;
    _array = [uint256(3),2,1];
}
```

## 解构赋值

```
// 命名式返回
    function returnNamed() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array){
        _number = 2;
         _bool = false;
        _array = [uint256(3),2,1];
    }

    function returnfunc() public pure {
        uint256 _number;
        bool _bool;
        uint256[3] memory _array;
        (_number, _bool, _array) = returnNamed();
    }
```

# 三 DataStorage

## 1.引用类型

**引用类型(Reference Type)**：包括数组（`array`）和结构体（`struct`），由于这类变量比较复杂，占用存储空间大，我们在使用时必须要声明数据存储的位置。

## 2.数据位置

Solidity数据存储位置有三类：`storage`，`memory`和`calldata`。不同存储位置的`gas`成本不同。`storage`类型的数据存在链上，类似计算机的硬盘，消耗`gas`多；`memory`和`calldata`类型的临时存在内存里，消耗`gas`少。大致用法：

1. `storage`：合约里的状态变量默认都是`storage`，存储在链上。
2. `memory`：函数里的参数和临时变量一般用`memory`，存储在内存中，不上链。
3. `calldata`：和`memory`类似，存储在内存中，不上链。与`memory`的不同点在于`calldata`变量不能修改（`immutable`），一般用于函数的参数。例子：

```
function fCalldata(uint[] calldata _x) public pure returns(uint[] calldata){
    //参数为calldata数组，不能被修改
    // _x[0] = 0 //这样修改会报错
    return(_x);
}
```

 	1.`storage`（合约的状态变量）赋值给本地`storage`（函数里的）时候，会创建引用，改变新变量会影响原变量 类似c++

​	2.`memory`也是引用赋值

## 3.变量作用域

`	Solidity`中变量按作用域划分有三种，分别是状态变量（state variable），局部变量（local variable）和全局变量(global variable)

## 4.状态变量

​	状态变量是数据存储在链上的变量，所有合约内函数都可以访问，`gas`消耗高。状态变量在合约内、函数外声明

```
contract Variables {
    uint public x = 1;
    uint public y;
    string public z;
}
```

​	我们可以在函数里更改状态变量的值：

```
function foo() external{
    // 可以在函数里更改状态变量的值
    x = 5;
    y = 2;
    z = "0xAA";
}
```

## 5.局部变量

​	局部变量是仅在函数执行过程中有效的变量，函数退出后，变量无效。局部变量的数据存储在内存里，不上链，`gas`低。

## 6.全局变量

全局变量是全局范围工作的变量，都是`solidity`预留关键字。他们可以在函数内不声明直接使用：

```
function global() external view returns(address, uint, bytes memory){
    address sender = msg.sender;
    uint blockNum = block.number;
    bytes memory data = msg.data;
    return(sender, blockNum, data);
}
```

完整的列表请看这个[链接](https://learnblockchain.cn/docs/solidity/units-and-global-variables.html#special-variables-and-functions).

### 3.6.1以太单位

`Solidity`中不存在小数点，以`0`代替为小数点，来确保交易的精确度，并且防止精度的损失，利用以太单位可以避免误算的问题，方便程序员在合约中处理货币交易。

- `wei`: 1
- `gwei`: 1e9 = 1000000000
- `ether`: 1e18 = 1000000000000000000

可以在合约中规定一个操作必须在一周内完成，或者某个事件在一个月后发生。这样就能让合约的执行可以更加精确，不会因为技术上的误差而影响合约的结果。因此，时间单位在`Solidity`中是一个重要的概念，有助于提高合约的可读性和可维护性。

- `seconds`: 1
- `minutes`: 60 seconds = 60
- `hours`: 60 minutes = 3600
- `days`: 24 hours = 86400
- `weeks`: 7 days = 604800

# 四 Array struct

## 1.Array

数组（`Array`）是`Solidity`常用的一种变量类型，用来存储一组数据（整数，字节，地址等等）。数组分为固定长度数组和可变长度数组两种：

- 固定长度数组：在声明时指定数组的长度。用`T[k]`的格式声明，其中`T`是元素的类型，`k`是长度，例如：

  ```
  // 固定长度 Array
  uint[8] array1;
  bytes1[5] array2;
  address[100] array3;
  ```

- 可变长度数组（动态数组）：在声明时不指定数组的长度。用`T[]`的格式声明，其中`T`是元素的类型，例如：

  ```
  // 可变长度 Array
  uint[] array4;
  bytes1[] array5;
  address[] array6;
  bytes array7;
  ```



  **注意**：`bytes`比较特殊，是数组，但是不用加`[]`。另外，不能用`byte[]`声明单字节数组，可以使用`bytes`或`bytes1[]`。`bytes` 比 `bytes1[]` 省gas。

  下面的例子中，如果没有对传入 `g()` 函数的数组进行 `uint` 转换，是会报错的。

```
 function f() public pure {
        g([uint(1), 2, 3]);
    }
    function g(uint[3] memory _data) public pure {
        // ...
    }
```

### 4.1.1Array Members

- `length`: 数组有一个包含元素数量的`length`成员，`memory`数组的长度在创建后是固定的。
- `push()`: `动态数组`拥有`push()`成员，可以在数组最后添加一个`0`元素，并返回该元素的引用。
- `push(x)`: `动态数组`拥有`push(x)`成员，可以在数组最后添加一个`x`元素。
- `pop()`: `动态数组`拥有`pop()`成员，可以移除数组最后一个元素。

## 2.Struct

`Solidity`支持通过构造结构体的形式定义新的类型。结构体中的元素**可以是原始类型，也可以是引用类型**；结构体可以作为数组或映射的元素。

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Test {
    // 结构体
    struct Student {
        uint256 id;
        uint256 score;
    }

    Student student; // 初始一个student结构体

    //  给结构体赋值
    // 方法1:在函数中创建一个storage的struct引用
    function initStudent1() external{
        Student storage _student = student; // assign a copy of student
        _student.id = 11;
        _student.score = 100;
    }

    // 方法2:直接引用状态变量的struct
    function initStudent2() external{
         student.id = 1;
        student.score = 80;
    }
    // 方法3:构造函数式
    function initStudent3() external {
        student = Student(3, 90);
    }

    // 方法4:key value
    function initStudent4() external {
        student = Student({id: 4, score: 60});
    }
}

```

# 五 Mapping

## 1.声明

在映射中，人们可以通过键（`Key`）来查询对应的值（`Value`），比如：通过一个人的`id`来查询他的钱包地址。

声明映射的格式为`mapping(_KeyType => _ValueType)`，其中`_KeyType`和`_ValueType`分别是`Key`和`Value`的变量类型。例子：

```
mapping(uint => address) public idToAddress; // id映射到地址
mapping(address => address) public swapPair; // 币对的映射，地址到地址
```

## 2.规则

**规则1**：映射的`_KeyType`只能选择Solidity内置的值类型，比如`uint`，`address`等，不能用自定义的结构体。而`_ValueType`可以使用自定义的类型

- **规则2**：映射的存储位置必须是`storage`，因此可以用于合约的状态变量，函数中的`storage`变量和library函数的参数。不能用于`public`函数的参数或返回结果中，因为`mapping`记录的是一种关系 (key - value pair)。
- **规则3**：如果映射声明为`public`，那么Solidity会自动给你创建一个`getter`函数，可以通过`Key`来查询对应的`Value`。
- **规则4**：给映射新增的键值对的语法为`_Var[_Key] = _Value`，其中`_Var`是映射变量名，`_Key`和`_Value`对应新增的键值对。

## 3.原理

- **原理1**: 映射不储存任何键（`Key`）的资讯，也没有length的资讯。
- **原理2**: 映射使用`keccak256(abi.encodePacked(key, slot))`当成offset存取value，其中`slot`是映射变量定义所在的插槽位置。
- **原理3**: 因为Ethereum会定义所有未使用的空间为0，所以未赋值（`Value`）的键（`Key`）初始值都是各个type的默认值，如uint的默认值是0。

# 六 constant&immutable

1.constant

`constant`变量必须在声明的时候初始化，之后再也不能改变。尝试改变的话，编译不通过。

2.immutable

变量可以在声明时或构造函数中初始化，因此更加灵活。

在下面这个例子，我们利用了`test()`函数给`IMMUTABLE_TEST`初始化为`9`：

```
// 利用constructor初始化immutable变量，因此可以利用
constructor(){
    IMMUTABLE_ADDRESS = address(this);
    IMMUTABLE_BLOCK = block.number;
    IMMUTABLE_TEST = test();
}

function test() public pure returns(uint256){
    uint256 what = 9;
    return(what);
}
```

