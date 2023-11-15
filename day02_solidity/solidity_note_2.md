# 一 构造函数&修饰器

## 1 构造函数

构造函数（`constructor`）是一种特殊的函数，每个合约可以定义一个，并在部署合约的时候自动运行一次。它可以用来初始化合约的一些参数，例如初始化合约的`owner`地址：

```
address owner; // 定义owner变量

// 构造函数
constructor() {
   owner = msg.sender; // 在部署合约的时候，将owner设置为部署者的地址
}
```

## 2 修饰器

修饰器（`modifier`）是`Solidity`特有的语法，`modifier`的主要使用场景是运行函数前的检查，例如地址，变量，余额等。

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Test {
    address public owner; // 定义owner变量

    constructor() {
        owner = msg.sender; // 在部署合约的时候，将owner设置为部署者的地址
    }

    // 定义modifier
    modifier onlyOwner() {
        require(msg.sender == owner); // 检查调用者是否为owner地址
        _; // 如果是的话，继续运行函数主体；否则报错并revert交易
    }

    function changeOwner(address _newOwner) external onlyOwner {
        owner = _newOwner; // 只有owner地址运行这个函数，并改变owner
    }
}


```

我们定义了一个`changeOwner`函数，运行它可以改变合约的`owner`，但是由于`onlyOwner`修饰符的存在，只有原先的`owner`可以调用，别人调用就会报错。这也是最常用的控制智能合约权限的方法。如图:

https://github.com/fly-1-1/Ethereum-Learning-Notes/blob/3e524529cad19f8cc1dfa839b653022772ad932e/day02_solidity/solidity_img/%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_20231116023755.png

# 二 事件

我们用转账ERC20代币为例来介绍`Solidity`中的事件（`event`）

## 1 事件

`Solidity`中的事件（`event`）是`EVM`上日志的抽象，它具有两个特点：

- 响应：应用程序（[`ethers.js`](https://learnblockchain.cn/docs/ethers.js/api-contract.html#id18)）可以通过`RPC`接口订阅和监听这些事件，并在前端做响应。
- 经济：事件是`EVM`上比较经济的存储数据的方式**，每个大概消耗2,000 `gas`**；相比之下，链上存储一个新变量至少需要20,000 `gas`。

## 2 声明事件

事件的声明由`event`关键字开头，接着是事件名称，括号里面写好事件需要记录的变量类型和变量名。以`ERC20`代币合约的`Transfer`事件为例：from`和`to`前面带有`indexed`关键字，他们会保存在以太坊虚拟机日志的`topics`中，方便之后检索。

```
event Transfer(address indexed from, address indexed to, uint256 value);
```

## 3 释放事件

我们可以在函数里释放事件。在下面的例子中，每次用`_transfer()`函数进行转账操作的时候，都会释放`Transfer`事件，并记录相应的变量。

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Test {

    mapping (address=>uint256) _balances;

    event Transfer(address indexed from, address indexed to, uint256 value);

    // 定义_transfer函数，执行转账逻辑
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) external {
        _balances[from] = 10*10**18;// 给转账地址一些初始代币
        _balances[from] -= amount; // from地址减去转账数量
        _balances[to] += amount; // to地址加上转账数量
        // 释放事件
        emit Transfer(from, to, amount);
    }
}

```

# 三 继承

`solidity`中的继承（`inheritance`），包括简单继承，多重继承，以及修饰器（`modifier`）和构造函数（`constructor`）的继承。

## 1 继承

继承是面向对象编程很重要的组成部分，可以显著减少重复代码。如果把合约看作是对象的话，`solidity`也是面向对象的编程，也支持继承。

### 3.1.1规则

- `virtual`: 父合约中的函数，如果希望子合约重写，需要加上`virtual`关键字。
- `override`：子合约重写了父合约中的函数，需要加上`override`关键字。

**注意**：用`override`修饰`public`变量，会重写与变量同名的`getter`函数，例如：

```
mapping(address => uint256) public override balanceOf;
```

### 3.1.2 简单继承

我们先写一个简单的爷爷合约`Yeye`，里面包含1个`Log`事件和3个`function`: `hip()`， `pop()`， `yeye()`，输出都是”Yeye”。我们再定义一个爸爸合约`Baba`，让他继承`Yeye`合约，语法就是`contract Baba is Yeye`，非常直观。在`Baba`合约里，我们重写一下`hip()`和`pop()`这两个函数，加上`override`关键字，并将他们的输出改为`”Baba”`；并且加一个新的函数`baba`，输出也是`”Baba”`。

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Yeye {
    event Log(string msg);

    // 定义3个function: hip(), pop(), man()，Log值为Yeye。
    function hip() public virtual{
        emit Log("Yeye");
    }

    function pop() public virtual{
        emit Log("Yeye");
    }

    function yeye() public virtual {
        emit Log("Yeye");
    }
}

contract Baba is Yeye{
    // 继承两个function: hip()和pop()，输出改为Baba。
    function hip() public virtual override{
        emit Log("Baba");
    }

    function pop() public virtual override{
        emit Log("Baba");
    }

    function baba() public virtual{
        emit Log("Baba");
    }
}



```

### 3.1.3 多重继承 类似C++

1. 继承时要按辈分最高到最低的顺序排。比如我们写一个`Erzi`合约，继承`Yeye`合约和`Baba`合约，那么就要写成`contract Erzi is Yeye, Baba`，而不能写成`contract Erzi is Baba, Yeye`，不然就会报错。

2. 如果某一个函数在多个继承的合约里都存在，比如例子中的`hip()`和`pop()`，在子合约里必须重写，不然会报错。

3. 重写在多个父合约中都重名的函数时，`override`关键字后面要**加上所有父合约名字**，例如`override(Yeye, Baba)`。

   ```
   contract Erzi is Yeye, Baba{
       // 继承两个function: hip()和pop()，输出值为Erzi。
       function hip() public virtual override(Yeye, Baba){
           emit Log("Erzi");
       }
   
       function pop() public virtual override(Yeye, Baba) {
           emit Log("Erzi");
       }
   ```



   ### 3.1.4 修饰器的继承

   `Solidity`中的修饰器（`Modifier`）同样可以继承，用法与函数继承类似，在相应的地方加`virtual`和`override`关键字即可。

```
contract Base1 {
    modifier exactDividedBy2And3(uint _a) virtual {
        require(_a % 2 == 0 && _a % 3 == 0);
        _;
    }
}

contract Identifier is Base1 {

    //计算一个数分别被2除和被3除的值，但是传入的参数必须是2和3的倍数
    function getExactDividedBy2And3(uint _dividend) public exactDividedBy2And3(_dividend) pure returns(uint, uint) {
        return getExactDividedBy2And3WithoutModifier(_dividend);
    }

    //计算一个数分别被2除和被3除的值
    function getExactDividedBy2And3WithoutModifier(uint _dividend) public pure returns(uint, uint){
        uint div2 = _dividend / 2;
        uint div3 = _dividend / 3;
        return (div2, div3);
    }
}
```

`Identifier`合约可以直接在代码中使用父合约中的`exactDividedBy2And3`修饰器，也可以利用`override`关键字重写修饰器：

```
   modifier exactDividedBy2And3(uint _a) override {
        _;
        require(_a % 2 == 0 && _a % 3 == 0);
    }
```

### 3.1.4 构造函数继承

子合约有两种方法继承父合约的构造函数。举个简单的例子，父合约`A`里面有一个状态变量`a`，并由构造函数的参数来确定：

```
// 构造函数的继承
abstract contract A {
    uint public a;

    constructor(uint _a) {
        a = _a;
    }
}
```

1. 在继承时声明父构造函数的参数，例如：`contract B is A(1)`
2. 在子合约的构造函数中声明构造函数的参数，例如：

```
contract C is A {
    constructor(uint _c) A(_c * _c) {}
}
```

### 3.1.5 调用父合约函数

1. 直接调用：子合约可以直接用`父合约名.函数名()`的方式来调用父合约函数，例如`Yeye.pop()`。

1. `super`关键字：子合约可以利用`super.函数名()`来调用最近的父合约函数。`solidity`继承关系按声明时从右到左的顺序是：`contract Erzi is Yeye, Baba`，那么`Baba`是最近的父合约，`super.pop()`将调用`Baba.pop()`而不是`Yeye.pop()`：

# 四 抽象合约&接口

## 1 抽象合约

 类似c++纯虚函数，如果一个智能合约里至少有一个未实现的函数，即某个函数缺少主体`{}`中的内容，则必须将该合约标为`abstract`，不然编译会报错；另外，未实现的函数需要加`virtual`

## 2 接口

接口类似于抽象合约，但它不实现任何功能。接口的规则：

1. 不能包含状态变量
2. 不能包含构造函数
3. 不能继承除接口外的其他合约
4. 所有函数都必须是external且不能有函数体
5. 继承接口的非抽象合约必须实现接口定义的所有功能

接口与合约`ABI`（Application Binary Interface）等价，可以相互转换：编译接口可以得到合约的`ABI`，利用[abi-to-sol工具](https://gnidan.github.io/abi-to-sol/)也可以将`ABI json`文件转换为`接口sol`文件。

### 4.2.1 IREC721事件

`IERC721`包含3个事件，其中`Transfer`和`Approval`事件在`ERC20`中也有。

- `Transfer`事件：在转账时被释放，记录代币的发出地址`from`，接收地址`to`和`tokenid`。
- `Approval`事件：在授权时释放，记录授权地址`owner`，被授权地址`approved`和`tokenid`。
- `ApprovalForAll`事件：在批量授权时释放，记录批量授权的发出地址`owner`，被授权地址`operator`和授权与否的`approved`。

### 4.2.2 IREC721函数

- `balanceOf`：返回某地址的NFT持有量`balance`。

- `ownerOf`：返回某`tokenId`的主人`owner`。

- `transferFrom`：普通转账，参数为转出地址`from`，接收地址`to`和`tokenId`。

- `safeTransferFrom`：安全转账（如果接收方是合约地址，会要求实现`ERC721Receiver`接口）。参数为转出地址`from`，接收地址`to`和`tokenId`。

- `approve`：授权另一个地址使用你的NFT。参数为被授权地址`approve`和`tokenId`。

- `getApproved`：查询`tokenId`被批准给了哪个地址。

- `setApprovalForAll`：将自己持有的该系列NFT批量授权给某个地址`operator`。

- `isApprovedForAll`：查询某地址的NFT是否批量授权给了另一个`operator`地址。

- `safeTransferFrom`：安全转账的重载函数，参数里面包含了`data`。


# 五 异常

## 1 Error

`error`是`solidity 0.8.4版本`新加的内容，方便且高效（省`gas`）地向用户解释操作失败的原因，同时还可以在抛出异常的同时携带参数，帮助开发者更好地调试。人们可以在`contract`之外定义异常

在执行当中，`error`必须搭配`revert`（回退）命令使用。

```
   function transferOwner1(uint256 tokenId, address newOwner) public {
        if(_owners[tokenId] != msg.sender){
            revert TransferNotOwner();
            // revert TransferNotOwner(msg.sender);
        }
        _owners[tokenId] = newOwner;
    }
```



## 2 Require

`require`命令是`solidity 0.8版本`之前抛出异常的常用方法，目前很多主流合约仍然还在使用它。它很好用，唯一的缺点就是`gas`随着描述异常的字符串长度增加，比`error`命令要高。使用方法：`require(检查条件，"异常的描述")`，当检查条件不成立的时候，就会抛出异常。

```
    function transferOwner2(uint256 tokenId, address newOwner) public {
        require(_owners[tokenId] == msg.sender, "Transfer Not Owner");
        _owners[tokenId] = newOwner;
    }
```

## 3 Assert

`assert`命令一般用于程序员写程序`debug`，因为它不能解释抛出异常的原因（比`require`少个字符串）。它的用法很简单，`assert(检查条件）`，当检查条件不成立的时候，就会抛出异常。

```
    function transferOwner3(uint256 tokenId, address newOwner) public {
        assert(_owners[tokenId] == msg.sender);
        _owners[tokenId] = newOwner;
    }
```

# 六 函数重载

`solidity`中允许函数进行重载（`overloading`），即名字相同但输入参数类型不同的函数可以同时存在，他们被视为不同的函数。注意，`solidity`不允许修饰器（`modifier`）重载。

# 七 接收ETH和fallback

## 1 receive

​	receive()`函数是在合约收到`ETH`转账时被调用的函数。一个合约最多有一个`receive()`函数，声明方式与一般函数不一样，不需要`function`关键字：`receive() external payable { ... }`。`receive()`函数不能有任何的参数，不能返回任何值，必须包含`external`和`payable`。当合约接收ETH的时候，`receive()`会被触发。`receive()`最好不要执行太多的逻辑因为如果别人用`send`和`transfer`方法发送`ETH`的话，`gas`会限制在`2300`，`receive()`太复杂可能会触发`Out of Gas`报错；如果用`call`就可以自定义`gas`执行更复杂的逻辑

  	我们可以在`receive()`里发送一个`event`

```
    // 定义事件
    event Received(address Sender, uint Value);
    // 接收ETH时释放Received事件
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
```

​	**有些恶意合约，会在`receive()` 函数（老版本的话，就是 `fallback()` 函数）嵌入恶意消耗`gas`的内容或者使得执行故意失败的代码，导致一些包含退款和转账逻辑的合约不能正常工作，因此写包含退款等逻辑的合约时候，一定要注意这种情况。**

## 2 fallback

`fallback()`函数会在调用合约不存在的函数时被触发。可用于接收ETH，也可以用于代理合约`proxy contract`。`fallback()`声明时不需要`function`关键字，必须由`external`修饰，一般也会用`payable`修饰，用于接收ETH:`fallback() external payable { ... }`。

我们定义一个`fallback()`函数，被触发时候会释放`fallbackCalled`事件，并输出`msg.sender`，`msg.value`和`msg.data`:

```
    event fallbackCalled(address Sender, uint Value, bytes Data);

    // fallback
    fallback() external payable{
        emit fallbackCalled(msg.sender, msg.value, msg.data);
    }
```

# 八 发送ETH

`Solidity`有三种方法向其他合约发送`ETH`，他们是：`transfer()`，`send()`和`call()`，其中`call()`是被鼓励的用法。

## 1 接收ETH合约

```
contract ReceiveETH {
    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);
    
    // receive方法，接收eth时被触发
    receive() external payable{
        emit Log(msg.value, gasleft());
    }
    
    // 返回合约ETH余额
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }
}
```

```
contract SendETH {
    // 构造函数，payable使得部署的时候可以转eth进去
    constructor() payable{}
    // receive方法，接收eth时被触发
    receive() external payable{}
}
```

如图

https://github.com/fly-1-1/Ethereum-Learning-Notes/blob/c83f7460a61571650a3002902ebaa55968f1fbc8/day02_solidity/solidity_img/2.png

## 2 transfer

- 用法是`接收方地址.transfer(发送ETH数额)`。
- `transfer()`的`gas`限制是`2300`，足够用于转账，但对方合约的`fallback()`或`receive()`函数不能实现太复杂的逻辑。
- `transfer()`如果转账失败，会自动`revert`（回滚交易）。

代码样例，注意里面的`_to`填`ReceiveETH`合约的地址，`amount`是`ETH`转账金额：

```
// 用transfer()发送ETH
function transferETH(address payable _to, uint256 amount) external payable{
	_to.transfer(amount);
}
```

## 3 send

- 用法是`接收方地址.send(发送ETH数额)`。

- `send()`的`gas`限制是`2300`，足够用于转账，但对方合约的`fallback()`或`receive()`函数不能实现太复杂的逻辑。

- `send()`如果转账失败，不会`revert`。

- `send()`的返回值是`bool`，代表着转账成功或失败，需要额外代码处理一下。

  ```
  // send()发送ETH
  function sendETH(address payable _to, uint256 amount) external payable{
      // 处理下send的返回值，如果失败，revert交易并发送error
      bool success = _to.send(amount);
      if(!success){
      	revert SendFailed();
      }
  }
  ```


## 4 call

- 用法是`接收方地址.call{value: 发送ETH数额}("")`。
- `call()`没有`gas`限制，可以支持对方合约`fallback()`或`receive()`函数实现复杂逻辑。
- `call()`如果转账失败，不会`revert`。
- `call()`的返回值是`(bool, bytes)`，其中`bool`代表着转账成功或失败，需要额外代码处理一下。

```
// call()发送ETH
function callETH(address payable _to, uint256 amount) external payable{
    // 处理下call的返回值，如果失败，revert交易并发送error
    (bool success,) = _to.call{value: amount}("");
    if(!success){
    	revert CallFailed();
    }
}
```

