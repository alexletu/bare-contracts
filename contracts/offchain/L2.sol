// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "../Interfaces/IERC20.sol";

/**
 * @param recipient the person (address of some account, to which money is owed
 * as a result of the account owner depositing ethreum to our entry bridge on
 * layer one)
 * @param amount the amount of (in this case) wrapped wei (MaticWETH or PoS-WETH)
 * that is owed to the receipient
 */
struct PayStub {
  address recipient;
  uint256 amount;
}

abstract contract L2 is Ownable {
  IERC20 internal wETH;
  event Disbursed(address, uint256);

  /**
   * @param  wrappedEther -IERCO20 token representation of Ether on the
   *  Polygon block chain.
   */
  constructor(address wrappedEther) payable Ownable() {
    wETH = IERC20(wrappedEther);
  }

  /**
   * @param payees An aray of PayStubs. Refer to above for PayStubs. Only the
   * owner of this contract can call this function.
   */
  function disburse(PayStub[] calldata payees) public onlyOwner {
    for (uint256 i = 0; i < payees.length; i++) {
      emit Disbursed(payees[i].recipient, payees[i].amount);
      wETH.transfer(payees[i].recipient, payees[i].amount);
    }
  }
}
