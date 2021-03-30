//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;


// interface for WETHGateway contract
interface IWETHGateway 
{
    function depositETH(
      address lendingPool,
      address onBehalfOf,
      uint16 referralCode
    ) external payable;

    function withdrawETH(
      address lendingPool,
      uint256 amount,
      address to
    ) external;

}

interface ILendingPoolProvider
{
   function getLendingPool() external view returns (address);
}