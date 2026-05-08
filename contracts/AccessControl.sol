// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title AccessControl
 * @dev fix privilege escalation bug
 * @custom:created 2026-05-08 21:59:46
 */
contract AccessControl {

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
     * @dev fix privilege escalation bug
     */
    function execute() public onlyAuthorized {
        totalCount++;
        emit ActionExecuted(msg.sender, block.timestamp);
    }

    function getCount() public view returns (uint256) {
        return totalCount;
    }
}
