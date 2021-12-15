// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IRootChainManager } from "../Interfaces/IRootChainManager.sol";

contract L1 is Ownable {
  address internal _receiver;
  IRootChainManager internal _rootChainManager;

  event Received(address, uint256);

  /**
   * @param receiver - the address of the contract on POLYGON that is the designated
   * receiver of any bridging calls that originate from this contract. This should be
   * set to the Layer two contract.
   * @param rootChainManager - The address of the contract `RootChainManager`
   */
  constructor(address receiver, address rootChainManager) Ownable() {
    _receiver = receiver;
    _rootChainManager = IRootChainManager(rootChainManager);
  }

  receive() external payable {
    deposit();
  }

  function deposit() public payable {
    emit Received(msg.sender, msg.value);
  }

  /**
   * @param newL2 the new Receipient on the layer two solution that will be receiving
   * this contract's bridged funds. Only callable by the owner.
   */
  function setReceiver(address newL2) public onlyOwner {
    _receiver = newL2;
  }

  /**
   * @notice this function will initiate a transfer of the ethereum held by this contract
   * to Polygon's blockchain. Note that the caller of this function will bear the full brunt
   * of the cost.
   */
  function transferToPolygon() public onlyOwner {
    _rootChainManager.depositEtherFor{ value: address(this).balance }(
      _receiver
    );
  }
}
