// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3TokensProcedure} from '../../../contracts/procedures/AaveV3TokensProcedure.sol';

contract AaveV3TokensBatch is AaveV3TokensProcedure {
  TokensReport internal _tokensReport;

  constructor(address poolProxy, address treasury, address underlyingAsset, address debtAsset) {
    _tokensReport = _deployAaveV3TokensImplementations(
      poolProxy,
      treasury,
      underlyingAsset,
      debtAsset
    );
  }

  function getTokensReport() external view returns (TokensReport memory) {
    return _tokensReport;
  }
}
