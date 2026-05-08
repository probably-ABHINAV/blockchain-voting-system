// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ElectionFactory
 * @dev add election creation factory contract
 * @custom:created 2026-05-08 21:59:41
 */
contract ElectionFactory {

    // State variables
    mapping(address => bool) public authorized;
    uint256 public totalCount;

    // Events
    event ActionExecuted(address indexed user, uint256 timestamp);

    // Modifiers
    modifier onlyAuthorized() {
        require(authorized[msg.sender], "Not authorized");
        _;
    }

    constructor() {
        authorized[msg.sender] = true;
    }

    /**
     * @dev add election creation factory contract
     */
    function execute() public onlyAuthorized {
        totalCount++;
        emit ActionExecuted(msg.sender, block.timestamp);
    }

    function getCount() public view returns (uint256) {
        return totalCount;
    }
}
