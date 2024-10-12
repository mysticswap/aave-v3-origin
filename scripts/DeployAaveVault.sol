// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {DeployAaveVaultBase} from './misc/DeployAaveVaultBase.sol';

import {DefaultMarketInput} from '../src/deployments/inputs/DefaultMarketInput.sol';

contract Default is DeployAaveVaultBase, DefaultMarketInput {}