pragma solidity ^0.8.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/demo.sol";

contract TestSimpledemo {

  function testItStoresAValue() public {
    demo d = Simpledemo(DeployedAddresses.demo());

    d.set(89);

    uint expected = 89;

    Assert.equal(d.get(), expected, "It should store the value 89.");
  }

}
