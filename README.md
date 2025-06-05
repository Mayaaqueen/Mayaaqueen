# Zyra - Token Factory & LP Locker

Zyra is a comprehensive DeFi platform that allows users to deploy tokens with automatic Uniswap pool creation and liquidity locking. The platform consists of two main smart contracts and a modern web interface.

## 🚀 Features

### Token Factory
- **One-click token deployment** with automatic Uniswap V3 pool creation
- **Single-sided liquidity provision** (tokens + ETH)
- **Automatic LP NFT locking** for security and trust
- **Pre-buy functionality** for token creators
- **Configurable lock durations**

### LP Locker
- **Secure NFT locking** with time-based unlocks
- **Fee collection** from Uniswap positions while locked
- **Batch operations** for efficiency
- **Emergency withdrawal** capabilities
- **Owner-only controls** for maximum security

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- [Node.js](https://nodejs.org/) (v18 or higher)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/)

## 🛠 Installation

### 1. Clone the Repository
\`\`\`bash
git clone <your-repo-url>
cd zyra
\`\`\`

### 2. Install Foundry Dependencies
\`\`\`bash
# Initialize Foundry project
forge init --force

# Install OpenZeppelin contracts
forge install OpenZeppelin/openzeppelin-contracts

# Install Uniswap V3 contracts
forge install Uniswap/v3-core
forge install Uniswap/v3-periphery

# Update dependencies
forge update
\`\`\`

### 3. Configure Foundry
Create or update \`foundry.toml\`:
\`\`\`toml
[profile.default]
src = "contracts"
out = "out"
libs = ["lib"]
remappings = [
    "@openzeppelin/=lib/openzeppelin-contracts/",
    "@uniswap/v3-core/=lib/v3-core/",
    "@uniswap/v3-periphery/=lib/v3-periphery/"
]

[rpc_endpoints]
base = "https://mainnet.base.org"
base_sepolia = "https://sepolia.base.org"

[etherscan]
base = { key = "${BASESCAN_API_KEY}" }
base_sepolia = { key = "${BASESCAN_API_KEY}" }
\`\`\`

### 4. Install Frontend Dependencies
\`\`\`bash
npm install
\`\`\`

### 5. Environment Setup
Create \`.env\` file:
\`\`\`env
# Private key for deployment (without 0x prefix)
PRIVATE_KEY=your_private_key_here

# RPC URLs
BASE_RPC_URL=https://mainnet.base.org
BASE_SEPOLIA_RPC_URL=https://sepolia.base.org

# Etherscan API key for contract verification
BASESCAN_API_KEY=your_basescan_api_key

# Frontend environment variables
NEXT_PUBLIC_ZYRA_FACTORY_ADDRESS=
NEXT_PUBLIC_ZYRA_LOCKER_ADDRESS=
NEXT_PUBLIC_NETWORK=base
\`\`\`

## 📦 Smart Contract Dependencies

The project uses the following key dependencies:

### OpenZeppelin Contracts
- \`@openzeppelin/contracts/token/ERC20/ERC20.sol\`
- \`@openzeppelin/contracts/access/Ownable.sol\`
- \`@openzeppelin/contracts/security/ReentrancyGuard.sol\`
- \`@openzeppelin/contracts/token/ERC721/IERC721.sol\`
- \`@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol\`
- \`@openzeppelin/contracts/utils/Counters.sol\`

### Uniswap V3 Contracts
- \`@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol\`
- \`@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol\`
- \`@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol\`
- \`@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol\`

## 🚀 Deployment

### 1. Compile Contracts
\`\`\`bash
forge build
\`\`\`

### 2. Deploy to Testnet (Base Sepolia)
\`\`\`bash
# Deploy ZyraLocker first
forge create contracts/ZyraLocker.sol:ZyraLocker \\
    --rpc-url base_sepolia \\
    --private-key $PRIVATE_KEY \\
    --verify

# Deploy ZyraTokenFactory (pass locker address as constructor param)
forge create contracts/TokenFactory.sol:ZyraTokenFactory \\
    --rpc-url base_sepolia \\
    --private-key $PRIVATE_KEY \\
    --constructor-args <LOCKER_ADDRESS> \\
    --verify
\`\`\`

### 3. Deploy to Mainnet (Base)
\`\`\`bash
# Deploy ZyraLocker first
forge create contracts/ZyraLocker.sol:ZyraLocker \\
    --rpc-url base \\
    --private-key $PRIVATE_KEY \\
    --verify

# Deploy ZyraTokenFactory
forge create contracts/TokenFactory.sol:ZyraTokenFactory \\
    --rpc-url base \\
    --private-key $PRIVATE_KEY \\
    --constructor-args <LOCKER_ADDRESS> \\
    --verify
\`\`\`

### 4. Alternative: Using Deploy Script
Create \`script/Deploy.s.sol\`:
\`\`\`solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts/ZyraLocker.sol";
import "../contracts/TokenFactory.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy ZyraLocker
        ZyraLocker locker = new ZyraLocker();
        console.log("ZyraLocker deployed at:", address(locker));

        // Deploy ZyraTokenFactory
        ZyraTokenFactory factory = new ZyraTokenFactory(address(locker));
        console.log("ZyraTokenFactory deployed at:", address(factory));

        vm.stopBroadcast();
    }
}
\`\`\`

Run the script:
\`\`\`bash
# Testnet
forge script script/Deploy.s.sol --rpc-url base_sepolia --broadcast --verify

# Mainnet
forge script script/Deploy.s.sol --rpc-url base --broadcast --verify
\`\`\`

## 🌐 Frontend Development

### 1. Update Contract Addresses
After deployment, update the contract addresses in:
- \`lib/web3.js\`
- \`lib/locker-web3.js\`
- \`.env\` file

### 2. Start Development Server
\`\`\`bash
npm run dev
\`\`\`

### 3. Build for Production
\`\`\`bash
npm run build
npm start
\`\`\`

## 📝 Contract Addresses

### Base Mainnet
- **ZyraLocker**: \`TBD\`
- **ZyraTokenFactory**: \`TBD\`

### Base Sepolia (Testnet)
- **ZyraLocker**: \`TBD\`
- **ZyraTokenFactory**: \`TBD\`

### Uniswap V3 Addresses (Base)
- **Factory**: \`0x33128a8fC17869897dcE68Ed026d694621f6FDfD\`
- **Position Manager**: \`0x03a520b32C04BF3bEEf7BF5d4f4c8f0C5f3C4f3C\`
- **Swap Router**: \`0x2626664c2603336E57B271c5C0b26F421741e481\`
- **WETH**: \`0x4200000000000000000000000000000000000006\`

## 🔧 Configuration

### Frontend Configuration
Update \`lib/web3.js\` and \`lib/locker-web3.js\` with your deployed contract addresses:

\`\`\`javascript
const CONTRACTS = {
  base: {
    tokenFactory: "YOUR_FACTORY_ADDRESS",
    locker: "YOUR_LOCKER_ADDRESS"
  }
}
\`\`\`

### Smart Contract Configuration
- **Default lock duration**: 1 day (86400 seconds)
- **Deployment fee**: 0.001 ETH
- **Uniswap fee tier**: 0.3% (3000)
- **Minimum lock time**: 1 hour

## 🧪 Testing

### Run Contract Tests
\`\`\`bash
forge test
\`\`\`

### Run Frontend Tests
\`\`\`bash
npm test
\`\`\`

## 📚 Usage

### Deploy a Token
1. Connect your wallet
2. Fill in token details (name, symbol, supply)
3. Set lock duration (default: 1 day)
4. Send ETH for liquidity + deployment fee
5. Token is deployed, pool created, and LP locked automatically

### Manage Locked Positions
1. View all locked positions in the Locker interface
2. Collect trading fees anytime (if enabled)
3. Withdraw NFTs after lock period expires (owner only)
4. Extend lock periods if needed

## 🔒 Security Features

- **ReentrancyGuard**: Prevents reentrancy attacks
- **Ownable**: Owner-only functions for critical operations
- **Time-locked withdrawals**: NFTs can only be withdrawn after lock period
- **Fee collection**: Original owners can collect fees while locked
- **Emergency functions**: Owner can handle edge cases

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Disclaimer

This software is provided "as is" without warranty. Use at your own risk. Always audit smart contracts before mainnet deployment.

## 🆘 Support

For support and questions:
- Create an issue on GitHub
- Join our Discord community
- Check the documentation

---

**Zyra** - Secure Token Deployment & Liquidity Locking Platform
\`\`\`
