// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Ownable} from 'src/core/contracts/dependencies/openzeppelin/contracts/Ownable.sol';
import {IERC20} from 'src/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol';

contract MockParaSwapTokenTransferProxy is Ownable {
  function transferFrom(
    address token,
    address from,
    address to,
    uint256 amount
  ) external onlyOwner {
    IERC20(token).transferFrom(from, to, amount);
  }
}
