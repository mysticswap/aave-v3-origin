// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {Pool} from './Pool.sol';
import {IPoolAddressesProvider} from '../../interfaces/IPoolAddressesProvider.sol';
import {IL2Pool} from '../../interfaces/IL2Pool.sol';
import {CalldataLogic} from '../libraries/logic/CalldataLogic.sol';
import {IACLManager} from '../../interfaces/IACLManager.sol';
import {Errors} from '../libraries/helpers/Errors.sol';

/**
 * @title L2Pool
 * @author Aave
 * @notice Calldata optimized extension of the Pool contract allowing users to pass compact calldata representation
 * to reduce transaction costs on rollups.
 */
abstract contract BondPool is Pool, IL2Pool {

  /**
   * @dev Only approved liquidator can call functions marked by this modifier.
   */
  modifier onlyBondLiquidator() {
    _onlyBondLiquidator();
    _;
  }

  /**
   * @dev Only pool user can call functions marked by this modifier.
   */
  modifier onlyBondPoolUser() {
    _onlyBondPoolUser();
    _;
  }

  function _onlyBondPoolUser() internal view virtual {
    require(
      IACLManager(ADDRESSES_PROVIDER.getACLManager()).isBondPoolUser(msg.sender),
      Errors.CALLER_NOT_POOL_ADMIN
    );
  }

  function _onlyBondLiquidator() internal view virtual {
    require(
      IACLManager(ADDRESSES_PROVIDER.getACLManager()).isBondLiquidator(msg.sender),
      Errors.CALLER_NOT_POOL_ADMIN
    );
  }

  /// @inheritdoc IL2Pool
  function supply(bytes32 args) external override onlyBondPoolUser {
    (address asset, uint256 amount, uint16 referralCode) = CalldataLogic.decodeSupplyParams(
      _reservesList,
      args
    );

    supply(asset, amount, msg.sender, referralCode);
  }

  /// @inheritdoc IL2Pool
  function supplyWithPermit(bytes32 args, bytes32 r, bytes32 s) external override onlyBondPoolUser {
    (address asset, uint256 amount, uint16 referralCode, uint256 deadline, uint8 v) = CalldataLogic
      .decodeSupplyWithPermitParams(_reservesList, args);

    supplyWithPermit(asset, amount, msg.sender, referralCode, deadline, v, r, s);
  }

  /// @inheritdoc IL2Pool
  function withdraw(bytes32 args) external override onlyBondPoolUser returns (uint256) {
    (address asset, uint256 amount) = CalldataLogic.decodeWithdrawParams(_reservesList, args);

    return withdraw(asset, amount, msg.sender);
  }

  /// @inheritdoc IL2Pool
  function borrow(bytes32 args) external override onlyBondPoolUser {
    (address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode) = CalldataLogic
      .decodeBorrowParams(_reservesList, args);

    borrow(asset, amount, interestRateMode, referralCode, msg.sender);
  }

  /// @inheritdoc IL2Pool
  function repay(bytes32 args) external override onlyBondPoolUser returns (uint256) {
    (address asset, uint256 amount, uint256 interestRateMode) = CalldataLogic.decodeRepayParams(
      _reservesList,
      args
    );

    return repay(asset, amount, interestRateMode, msg.sender);
  }

  /// @inheritdoc IL2Pool
  function repayWithPermit(bytes32 args, bytes32 r, bytes32 s) external override onlyBondPoolUser returns (uint256) {
    (
      address asset,
      uint256 amount,
      uint256 interestRateMode,
      uint256 deadline,
      uint8 v
    ) = CalldataLogic.decodeRepayWithPermitParams(_reservesList, args);

    return repayWithPermit(asset, amount, interestRateMode, msg.sender, deadline, v, r, s);
  }

  /// @inheritdoc IL2Pool
  function repayWithATokens(bytes32 args) external override onlyBondPoolUser returns (uint256) {
    (address asset, uint256 amount, uint256 interestRateMode) = CalldataLogic.decodeRepayParams(
      _reservesList,
      args
    );

    return repayWithATokens(asset, amount, interestRateMode);
  }

  /// @inheritdoc IL2Pool
  function swapBorrowRateMode(bytes32 args) external override onlyBondPoolUser {
    (address asset, uint256 interestRateMode) = CalldataLogic.decodeSwapBorrowRateModeParams(
      _reservesList,
      args
    );
    swapBorrowRateMode(asset, interestRateMode);
  }

  /// @inheritdoc IL2Pool
  function rebalanceStableBorrowRate(bytes32 args) external override  onlyBondPoolUser{
    (address asset, address user) = CalldataLogic.decodeRebalanceStableBorrowRateParams(
      _reservesList,
      args
    );
    rebalanceStableBorrowRate(asset, user);
  }

  /// @inheritdoc IL2Pool
  function setUserUseReserveAsCollateral(bytes32 args) external override  onlyBondPoolUser{
    (address asset, bool useAsCollateral) = CalldataLogic.decodeSetUserUseReserveAsCollateralParams(
      _reservesList,
      args
    );
    setUserUseReserveAsCollateral(asset, useAsCollateral);
  }

  /// @inheritdoc IL2Pool
  function liquidationCall(bytes32 args1, bytes32 args2) external override onlyBondLiquidator {
    (
      address collateralAsset,
      address debtAsset,
      address user,
      uint256 debtToCover,
      bool receiveAToken
    ) = CalldataLogic.decodeLiquidationCallParams(_reservesList, args1, args2);
    liquidationCall(collateralAsset, debtAsset, user, debtToCover, receiveAToken);
  }
}
