// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { VRFConsumerBaseV2 } from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import { AutomationCompatibleInterface } from "lib/chainlink-brownie-contracts/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";

/**
 * @title Raffle Contract
 * @author Dan Magro
 * @notice This contract is for creating a simple raffle
 * @dev Implements Chainlink VRF to get random numbers
 */

contract Raffle is VRFConsumerBaseV2, AutomationCompatibleInterface {
    // Errors
    error Raffle__SendMoreToEnterRaffle();
    error Raffle__NotEnoughTimePassed();
    error Raffle__NoPlayers();
    error Raffle__RaffleNotOpen();

    // Events
    event RaffleEnter(address indexed player);

    // Types
    enum RaffleState {
        OPEN,       // 0
        CALCULATING // 1
    }

    // State Variables
    uint256 private immutable i_entranceFee;
    address[] private s_players;
    uint256 private s_lastTimeStamp;
    address private s_recentWinner;
    RaffleState private s_raffleState;
    
    // Time interval between raffle picks in seconds
    uint256 private immutable i_interval;

    // VRF Variables
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    address private immutable i_vrfCoordinator;

    constructor(
        uint64 subscriptionId,
        bytes32 gasLane,
        uint256 interval,
        uint256 entranceFee,
        uint32 callbackGasLimit,
        address vrfCoordinatorV2
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_subscriptionId = subscriptionId;
        i_gasLane = gasLane;
        i_interval = interval;
        i_entranceFee = entranceFee;
        i_callbackGasLimit = callbackGasLimit;
        i_vrfCoordinator = vrfCoordinatorV2;
        s_lastTimeStamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
    }

    function enterRaffle() public payable {
        // require(msg.value > i_entranceFee, "Not enough ETH sent");
        if(msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }

        s_players.push(payable(msg.sender));
        emit RaffleEnter(msg.sender);
    }

    // Get a random number
    // Use random number to pick a winner
    // Be automically called

    function pickWinner() public {
        // check to see if enough time has passed
        if ((block.timestamp - s_lastTimeStamp) <= i_interval) {
            revert Raffle__NotEnoughTimePassed();
        }

        // check to see if there are players
        if (s_players.length == 0) {
            revert Raffle__NoPlayers();
        }

        // TODO: Implement winner selection logic
        // For now, just reset the timestamp
        s_lastTimeStamp = block.timestamp;
    }

    /**
     * @dev Chainlink Automation function to check if upkeep is needed
     */
    function checkUpkeep(bytes memory /* checkData */) public view override returns (bool upkeepNeeded, bytes memory /* performData */) {
        bool isOpen = RaffleState.OPEN == s_raffleState;
        bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval);
        bool hasPlayers = s_players.length > 0;
        bool hasBalance = address(this).balance > 0;
        upkeepNeeded = (timePassed && isOpen && hasBalance && hasPlayers);
        return (upkeepNeeded, "0x0");
    }

    /**
     * @dev Chainlink Automation function to perform upkeep
     */
    function performUpkeep(bytes calldata /* performData */) external override {
        (bool upkeepNeeded,) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert("Upkeep not needed");
        }
        s_raffleState = RaffleState.CALCULATING;
        // TODO: Implement VRF request logic
        // For now, just reset the timestamp
        s_lastTimeStamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
    }

    /**
     * @dev Callback function used by VRF Coordinator to return the random number
     * @param requestId The request ID for fulfillment
     * @param randomWords Array of random words returned by VRF
     */
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        // TODO: Implement random winner selection logic
        // For now, this is just a placeholder
    }

    /** 
     * Getter Functions
     * 
     */

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }

    function getNumberOfPlayers() public view returns (uint256) {
        return s_players.length;
    }

    function getLastTimeStamp() public view returns (uint256) {
        return s_lastTimeStamp;
    }

    function getInterval() public view returns (uint256) {
        return i_interval;
    }

    function getRaffleState() public view returns (RaffleState) {
        return s_raffleState;
    }

    function getRecentWinner() public view returns (address) {
        return s_recentWinner;
    }
}   