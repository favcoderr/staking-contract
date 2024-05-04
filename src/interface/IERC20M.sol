//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC20M {
    function _mint(address account, uint256 value) external;
    function _burn(address account, uint256 value) external;
}