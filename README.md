# 🎰 Smart Contract Lottery with Chainlink VRF

A decentralized, provably fair lottery system built on Ethereum using Chainlink's Verifiable Random Function (VRF) for secure randomness and Chainlink Keepers for automated execution.

## 🎯 Project Overview

This project demonstrates how to build a secure, automated lottery system that cannot be manipulated by miners, contract owners, or any centralized entity. It leverages Chainlink's infrastructure to provide enterprise-grade randomness and automation while maintaining the security and transparency benefits of blockchain technology.

## 🏗️ Architecture

The lottery system consists of several key components:

- **Raffle Contract** - Core lottery logic and state management
- **VRF Integration** - Chainlink's randomness oracle for fair winner selection
- **Automation** - Chainlink Keepers for automated lottery execution
- **Deployment Scripts** - Automated setup and configuration management

## 🔐 Security Features

### Provably Fair Randomness
- **Cryptographic Proof**: Each random number comes with a cryptographic proof
- **Verifiable**: Anyone can verify the randomness was generated correctly
- **Unpredictable**: Even the VRF nodes cannot predict the output

### Manipulation Resistance
- **Miner Manipulation**: VRF prevents miners from manipulating outcomes
- **Front-running Protection**: Random numbers cannot be predicted or front-run
- **Transparent Execution**: All randomness is verifiable on-chain

## 🚀 How It Works

### 1. User Participation
Users enter the lottery by sending ETH (equal to the entrance fee) to the contract. Each entry is recorded and the user is added to the players array.

### 2. Automated Winner Selection
Chainlink Keepers automatically monitor the contract and trigger winner selection when:
- Enough time has passed since the last raffle
- There are players in the current raffle
- The contract has accumulated ETH from entrance fees

### 3. Secure Randomness Generation
When it's time to select a winner:
1. The contract requests random numbers from Chainlink VRF
2. VRF generates cryptographically secure randomness off-chain
3. The random number is delivered back to the contract with a cryptographic proof
4. A winner is selected using the formula: `randomNumber % numberOfPlayers`

### 4. Prize Distribution
The selected winner receives all accumulated ETH from the raffle, and the system resets for the next round.

## 🛠️ Technical Implementation

### VRF Integration
The contract integrates with Chainlink VRF v2.5, which provides:
- **Subscription Management**: Pre-funded accounts for VRF requests
- **Automatic Billing**: LINK tokens are deducted per request
- **Gas Optimization**: Efficient handling of multiple randomness requests

### Automation with Keepers
Chainlink Keepers provide:
- **Automatic Execution**: No manual intervention required
- **Reliable Timing**: Ensures raffles run on schedule
- **Gas Optimization**: Batched execution for cost efficiency

## 📋 Prerequisites

- [Foundry](https://getfoundry.sh/) - Ethereum development framework
- [Node.js](https://nodejs.org/) (v16 or higher)
- [Git](https://git-scm.com/)
- Ethereum wallet (MetaMask, etc.)
- Testnet ETH and LINK tokens (for testing)

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd foundry-smart-contract-lottery-cu
```

### 2. Install Dependencies
```bash
forge install
```

### 3. Set Environment Variables
Create a `.env` file in the root directory:
```env
PRIVATE_KEY=your_private_key_here
SEPOLIA_RPC_URL=your_sepolia_rpc_url_here
ETHERSCAN_API_KEY=your_etherscan_api_key_here
```

### 4. Compile the Contracts
```bash
forge build
```

### 5. Run Tests
```bash
forge test
```

## 🧪 Testing

The project includes comprehensive tests covering:
- Contract deployment and initialization
- User entry and fee collection
- VRF integration and randomness generation
- Winner selection and prize distribution
- Automation and upkeep mechanisms

Run tests with different verbosity levels:
```bash
# Basic test run
forge test

# Verbose output
forge test -vvv

# Very verbose with traces
forge test -vvvv
```

## 🚀 Deployment

### Local Development (Anvil)
```bash
# Start local blockchain
anvil

# Deploy to local network
forge script script/DeployRaffle.s.sol --rpc-url http://localhost:8545 --broadcast
```

### Sepolia Testnet
```bash
# Deploy to Sepolia
forge script script/DeployRaffle.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify
```

### Mainnet
```bash
# Deploy to mainnet (use with caution)
forge script script/DeployRaffle.s.sol --rpc-url $MAINNET_RPC_URL --broadcast --verify
```

## 💰 Funding Your VRF Subscription

### 1. Create Subscription
After deployment, create a VRF subscription:
```bash
forge script script/Interactions.s.sol:CreateSubscription --rpc-url $RPC_URL --broadcast
```

### 2. Fund Subscription
Fund your subscription with LINK tokens:
```bash
forge script script/Interactions.s.sol:FundSubscription --rpc-url $RPC_URL --broadcast
```

### 3. Add Consumer
Register your contract as a VRF consumer:
```bash
forge script script/Interactions.s.sol:AddConsumer --rpc-url $RPC_URL --broadcast
```

## 🎮 Interacting with the Platform

### For Users

#### Entering the Lottery
1. **Connect Wallet**: Connect your Ethereum wallet to the platform
2. **Check Entrance Fee**: Verify the current entrance fee (displayed on the UI)
3. **Send ETH**: Send the required amount of ETH to enter the raffle
4. **Wait for Draw**: The lottery will automatically run when conditions are met

#### Checking Status
- **Current State**: View whether the lottery is open, calculating, or closed
- **Player Count**: See how many people have entered
- **Time Remaining**: Check when the next draw will occur
- **Previous Winners**: View history of past winners

### For Developers

#### Contract Interaction
```solidity
// Enter the raffle
raffle.enterRaffle{value: entranceFee}();

// Check current state
Raffle.RaffleState state = raffle.getRaffleState();

// Get player count
uint256 playerCount = raffle.getNumberOfPlayers();

// Check if upkeep is needed
(bool upkeepNeeded,) = raffle.checkUpkeep("");
```

#### VRF Integration
```solidity
// Request random words
uint256 requestId = vrfCoordinator.requestRandomWords(
    VRFV2PlusClient.RandomWordsRequest({
        keyHash: gasLane,
        subId: subscriptionId,
        requestConfirmations: 3,
        callbackGasLimit: 500000,
        numWords: 1,
        extraArgs: VRFV2PlusClient._argsToBytes(
            VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
        )
    })
);
```

## 🔧 Configuration

### Network-Specific Settings

#### Local/Anvil (Chain ID 31337)
- Uses `VRFCoordinatorV2_5Mock` for testing
- No real costs involved
- Perfect for development and testing

#### Sepolia Testnet (Chain ID 11155111)
- Real Chainlink VRF coordinator
- Requires testnet LINK tokens
- Tests integration with actual infrastructure

#### Mainnet (Chain ID 1)
- Production-ready configuration
- Real LINK token costs
- Highest security and reliability

### Customization Options
- **Entrance Fee**: Adjust the cost to enter the lottery
- **Interval**: Set how often raffles can run
- **Gas Limits**: Configure VRF callback gas limits
- **Confirmation Blocks**: Set VRF request confirmation requirements

## 📊 Gas Optimization

### Best Practices
- **Batch Operations**: Group multiple operations when possible
- **Gas-Efficient Loops**: Use efficient iteration patterns
- **Storage Optimization**: Minimize storage operations
- **Event Optimization**: Use indexed parameters for efficient filtering

### Gas Costs Breakdown
- **Contract Deployment**: ~1.6M gas
- **User Entry**: ~48K gas
- **VRF Request**: ~150K gas
- **Winner Selection**: ~100K gas

## 🔍 Monitoring and Analytics

### Key Metrics to Track
- **Total Entries**: Number of lottery participants
- **Prize Pools**: Total ETH collected per raffle
- **Winner Distribution**: Fairness verification
- **Gas Usage**: Cost optimization opportunities

### Events to Monitor
```solidity
event RaffleEnter(address indexed player);
event RequestedRaffleWinner(uint256 indexed requestId);
event WinnerPicked(address indexed winner);
```

## 🚨 Troubleshooting

### Common Issues

#### VRF Request Fails
- Check subscription funding
- Verify consumer registration
- Ensure sufficient gas limits

#### Automation Not Working
- Verify keeper registration
- Check upkeep conditions
- Monitor gas prices

#### Contract Deployment Issues
- Verify network configuration
- Check private key permissions
- Ensure sufficient testnet ETH

### Debug Commands
```bash
# Check contract state
cast call <contract_address> "getRaffleState()"

# View contract balance
cast balance <contract_address>

# Check VRF subscription
cast call <vrf_address> "getSubscription(uint256)" <subscription_id>
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

### Code Standards
- Follow Solidity style guide
- Include comprehensive tests
- Add documentation for new features
- Ensure all tests pass

## 📚 Additional Resources

### Documentation
- [Chainlink VRF Documentation](https://docs.chain.link/vrf/v2/introduction)
- [Chainlink Keepers Documentation](https://docs.chain.link/chainlink-automation/introduction)
- [Foundry Book](https://book.getfoundry.sh/)

### Community
- [Chainlink Discord](https://discord.gg/chainlink)
- [Foundry Discord](https://discord.gg/getfoundry)
- [Ethereum Stack Exchange](https://ethereum.stackexchange.com/)

### Related Projects
- [Chainlink VRF Examples](https://github.com/smartcontractkit/chainlink-vrf)
- [Foundry Examples](https://github.com/foundry-rs/foundry/tree/master/examples)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This software is for educational purposes. Use at your own risk. The authors are not responsible for any financial losses or damages resulting from the use of this software.

## 🙏 Acknowledgments

- Chainlink team for VRF and Keepers infrastructure
- Foundry team for the development framework
- OpenZeppelin for secure contract libraries
- The Ethereum community for continuous innovation

---

**Built with ❤️ using Chainlink VRF and Foundry**

For questions or support, please open an issue on GitHub or reach out to the community.
