// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {L2PoolInstance} from 'aave-v3-core/instances/L2PoolInstance.sol';
import {BondPoolInstance} from 'aave-v3-core/instances/BondPoolInstance.sol';
import {TreasuryPoolInstance} from 'aave-v3-core/instances/TreasuryPoolInstance.sol';
import {PermissionedPoolInstance} from 'aave-v3-core/instances/PermissionedPoolInstance.sol';

import {IPoolAddressesProvider} from 'aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol';
import {AaveV3PoolConfigProcedure} from './AaveV3PoolConfigProcedure.sol';
import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';
import {IErrors} from '../../interfaces/IErrors.sol';
import '../../interfaces/IMarketReportTypes.sol';

contract AaveV3L2PoolProcedure is AaveV3PoolConfigProcedure, IErrors {
  function _deployAaveV3L2Pool(address poolAddressesProvider) internal returns (PoolReport memory) {
    if (poolAddressesProvider == address(0)) revert ProviderNotFound();

    PoolReport memory report;

    report.poolImplementation = _deployL2PoolImpl(poolAddressesProvider);
    report.poolConfiguratorImplementation = _deployPoolConfigurator(poolAddressesProvider);

    return report;
  }

  function _deployL2PoolImpl(address poolAddressesProvider) internal returns (address) {
    address l2Pool = address(new L2PoolInstance(IPoolAddressesProvider(poolAddressesProvider)));

    L2PoolInstance(l2Pool).initialize(IPoolAddressesProvider(poolAddressesProvider));

    return l2Pool;
  }

   function _deployBondPoolImpl(address poolAddressesProvider) internal returns (address) {
    address l2Pool = address(new BondPoolInstance(IPoolAddressesProvider(poolAddressesProvider)));

    BondPoolInstance(l2Pool).initialize(IPoolAddressesProvider(poolAddressesProvider));

    return l2Pool;
  }

   function _deployTreasuryPoolImpl(address poolAddressesProvider) internal returns (address) {
    address l2Pool = address(new TreasuryPoolInstance(IPoolAddressesProvider(poolAddressesProvider)));

    TreasuryPoolInstance(l2Pool).initialize(IPoolAddressesProvider(poolAddressesProvider));

    return l2Pool;
  }

   function _deployPermissionedPoolImpl(address poolAddressesProvider) internal returns (address) {
    address l2Pool = address(new PermissionedPoolInstance(IPoolAddressesProvider(poolAddressesProvider)));

    PermissionedPoolInstance(l2Pool).initialize(IPoolAddressesProvider(poolAddressesProvider));

    return l2Pool;
  }
}
