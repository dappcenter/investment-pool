pragma solidity ^0.4.23;

import "./BaseInvestmentPool.sol";


/**
 * @title WhitelistedInvestmentPool
 * @dev The contract extends BaseInvestmentPool and adds additional functionality:
 *      only whitelisted investors can send funds to the contract.
 */
contract WhitelistedInvestmentPool is BaseInvestmentPool {
  /**
   * @notice investors which can contribute funds to the contract.
   */
  mapping(address => bool) private whitelist;

  /**
   * @notice emitted when contract owner added new address to the whitelist.
   *
   * @param _address whitelisted address.
   */
  event WhitelistedAddressAdded(address indexed _address);

  /**
   * @notice emitted when contract owner removed address from the whitelist.
   *
   * @param _address address removed from whitelist.
   */
  event WhitelistedAddressRemoved(address indexed _address);

  /**
   * @dev throws if investor is not whitelisted.
   * @param _investor address
   */
  modifier onlyIfWhitelisted(address _investor) {
    require(whitelist[_investor]);
    _;
  }

  /**
   * @dev add single address to whitelist
   */
  function addAddressToWhitelist(address _address) external onlyOwner {
    whitelist[_address] = true;
    emit WhitelistedAddressAdded(_address);
  }

  /**
   * @dev add addresses to whitelist
   */
  function addAddressesToWhitelist(address[] _addresses) external onlyOwner {
    for (uint i = 0; i < _addresses.length; i++) {
      whitelist[_addresses[i]] = true;
      emit WhitelistedAddressAdded(_addresses[i]);
    }
  }

  /**
   * @dev remove single address from whitelist
   */
  function removeAddressFromWhitelist(address _address) external onlyOwner {
    delete whitelist[_address];
    emit WhitelistedAddressRemoved(_address);
  }

  /**
   * @dev remove addresses from whitelist
   */
  function removeAddressesFromWhitelist(address[] _addresses) external onlyOwner {
    for (uint i = 0; i < _addresses.length; i++) {
      delete whitelist[_addresses[i]];
      emit WhitelistedAddressRemoved(_addresses[i]);
    }
  }

  /**
   * @dev getter to determine if address is in whitelist
   */
  function isWhitelisted(address _address) public view returns (bool) {
    return whitelist[_address];
  }

  function _preValidateInvest(address _beneficiary, uint _amount) internal onlyIfWhitelisted(_beneficiary) {
    super._preValidateInvest(_beneficiary, _amount);
  }
}
