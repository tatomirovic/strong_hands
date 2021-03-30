//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;


import {IWETHGateway, ILendingPoolProvider} from "./Interfaces.sol";



/// @title Strong hands.
contract StrongHands {

  // WETHGateway contract
  IWETHGateway public WETHGateway = IWETHGateway(0xf8aC10E65F2073460aAD5f28E1EABE807DC287CF);

  // LendingPoolProvider contract address
  ILendingPoolProvider public LendingPoolProvider = ILendingPoolProvider(0x88757f2f99175387aB4C6a4b3067c77A695b0349);

  // address of lending pool for aave
  address LendingPool = address(0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe);

  /*
  *  struct for keeping track of deposited 
  *  ether and time of deposit for each
  *  external account
  */
  struct Deposit
  {
    uint timeOfDeposit;
    uint amount;
    uint index;
  }

  // mapping of all deposits
  mapping (address => Deposit) public deposits;

  /*
  * dynamic array of depositor addresses
  * needed for sharing ether of
  * pre-mature withdrawals
  */
  address[] depositors;

  // address of the contract creator
  address contractOwner;

  /* 
  * time to wait before the
  * account can withdraw 100%
  * of his initial deposit
  */
  uint lockTime;

  // keeping track of the total
  // deposited amount to the contract
  uint totalDeposit;


  modifier ownerOnly() { require(msg.sender == contractOwner, "Only the owner of the StrongHand contract can withdraw the profit!"); _;}

  // create StrongHands contract with given lock time
  constructor(uint _lockTime) 
  {
    lockTime = _lockTime;
    contractOwner = msg.sender;

    /* 
    * this could be at every transaction
    * to guarantee lending pool address
    * is always up to date
    */
    //this didnt work
    //LendingPool = LendingPoolProvider.getLendingPool();

    //totalDeposit = 0;
  }

  /**
  * Deposit ether to the contract, locking 
  * it for a period of time with a penalty 
  * to withdrawal before it expires.
  */ 
  function strongDeposit() 
  external 
  payable
  {
    deposits[msg.sender].amount += msg.value;
    deposits[msg.sender].timeOfDeposit = block.timestamp;
    totalDeposit += msg.value;
    if (deposits[msg.sender].index == 0)
    {
      // actual index + 1, so 0 is non-valid
      deposits[msg.sender].index = depositors.length + 1;
      depositors.push(msg.sender);   
    }

    //deposit to aave
    WETHGateway.depositETH{value: msg.value}(LendingPool, contractOwner, 0);
  }

  /**
  * Withdraw ether with a penalty of up to 50%
  * depending on how long the ether
  * was locked
  */ 
  function strongWithdraw() 
  external
  {
    require(deposits[msg.sender].amount > 0, "You haven't deposited any ether to this contract.");
    uint timePassed = block.timestamp - deposits[msg.sender].timeOfDeposit;
    uint withdrawAmount = deposits[msg.sender].amount;
    uint shareAmount = 0;
    if (timePassed <  lockTime)
    {
      //I'm not sure how this works without floating points 
      shareAmount = (withdrawAmount * (lockTime - timePassed)) / (lockTime * 2);
      withdrawAmount -= shareAmount;
      //sharing of remaining tokens
    }
    
    //withdraw from aave
    WETHGateway.withdrawETH(LendingPool, withdrawAmount, msg.sender);

    deposits[msg.sender].amount = 0;
    //maybe this should go after the sharing
    totalDeposit -= withdrawAmount;
    
    /* 
    * set last to withdrawer, remove him from depositors
    * change index of deposits to their respective depositors
    * after swap
    */
    depositors[deposits[msg.sender].index - 1] = depositors[depositors.length - 1];
    deposits[depositors[depositors.length - 1]].index = deposits[msg.sender].index;
    deposits[msg.sender].index = 0;
    depositors.pop(); 

    // iterate through others to share
    if(shareAmount > 0)
    {
      uint remainingAmount = shareAmount;
      uint addAmount;
      for (uint i = 0; i < depositors.length; i++)
      {
        addAmount = (deposits[depositors[i]].amount * shareAmount) / totalDeposit;
        if( addAmount > remainingAmount ) addAmount = remainingAmount;
        remainingAmount -= addAmount;
        deposits[depositors[i]].amount += addAmount;
      }
      // if any is left because of integer division
      // it will stay in the lendingpool
      // and be reaped with the profit
    }

  }


  function profitWithdraw() 
  external 
  ownerOnly
  {
    // take everything
    WETHGateway.withdrawETH(LendingPool, type(uint).max, address(this));
    // transfer profit
    payable(contractOwner).transfer( address(this).balance - totalDeposit);
    //put back rest into lendingpool
    WETHGateway.depositETH{value: totalDeposit}(LendingPool, contractOwner, 0);
    //i have no idea if this is how it works
  }

}
