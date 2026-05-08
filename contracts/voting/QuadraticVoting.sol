// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title QuadraticVoting
 * @dev implement quadratic voting mechanism
 * @custom:security-contact security@votingdao.org
 * @custom:created 2026-05-08 22:07:43
 */
contract QuadraticVoting is ERC20, AccessControl, ReentrancyGuard {

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant VOTER_ROLE = keccak256("VOTER_ROLE");

    struct Proposal {
        uint256 id;
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 startTime;
        uint256 endTime;
        bool executed;
        mapping(address => bool) hasVoted;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    event ProposalCreated(uint256 indexed proposalId, string description, uint256 startTime, uint256 endTime);
    event VoteCast(address indexed voter, uint256 indexed proposalId, bool support, uint256 weight);
    event ProposalExecuted(uint256 indexed proposalId);

    constructor() ERC20("QuadraticVoting", "VOTE") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev implement quadratic voting mechanism
     * @param proposalId The ID of the proposal
     * @param support Whether to vote for or against
     */
    function castVote(uint256 proposalId, bool support) external nonReentrant {
        require(hasRole(VOTER_ROLE, msg.sender), "Not authorized to vote");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.hasVoted[msg.sender], "Already voted");
        require(block.timestamp >= proposal.startTime && block.timestamp <= proposal.endTime, "Voting not active");

        uint256 weight = balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        if (support) {
            proposal.forVotes += weight;
        } else {
            proposal.againstVotes += weight;
        }

        proposal.hasVoted[msg.sender] = true;
        emit VoteCast(msg.sender, proposalId, support, weight);
    }

    function createProposal(string memory description, uint256 duration) external onlyRole(ADMIN_ROLE) returns (uint256) {
        uint256 proposalId = proposalCount++;
        Proposal storage proposal = proposals[proposalId];
        proposal.id = proposalId;
        proposal.description = description;
        proposal.startTime = block.timestamp;
        proposal.endTime = block.timestamp + duration;

        emit ProposalCreated(proposalId, description, proposal.startTime, proposal.endTime);
        return proposalId;
    }

    function getProposalVotes(uint256 proposalId) external view returns (uint256 forVotes, uint256 againstVotes) {
        Proposal storage proposal = proposals[proposalId];
        return (proposal.forVotes, proposal.againstVotes);
    }
}
