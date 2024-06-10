// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3GettersProcedureOne} from '../../../contracts/procedures/AaveV3GettersProcedureOne.sol';

contract AaveV3GettersBatchOne is AaveV3GettersProcedureOne {
  GettersReportBatchOne internal _gettersReport;

  constructor(
    address poolAddressesProvider,
    address networkBaseTokenPriceInUsdProxyAggregator,
    address marketReferenceCurrencyPriceInUsdProxyAggregator
  ) {
    _gettersReport = _deployAaveV3GettersBatchOne(
      poolAddressesProvider,
      networkBaseTokenPriceInUsdProxyAggregator,
      marketReferenceCurrencyPriceInUsdProxyAggregator
    ); // 2-1
  }

  function getGettersReportOne() external view returns (GettersReportBatchOne memory) {
    return _gettersReport;
  }
}
