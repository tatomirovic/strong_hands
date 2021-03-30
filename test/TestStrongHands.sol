pragma solidity >=0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/StrongHands.sol";
import "../contracts/Interfaces.sol";

// Couldn't test, kept getting artifact not
// found for Interfaces.sol, didn't manage to 
// solve it by reinstalling truffle or
// deleting build folder
contract TestStrongHands {
    function testDeposit() public {
        StrongHands strongHands = StrongHands(DeployedAddresses.StrongHands());

        strongHands.strongDeposit{value: 1000}();
    }
}