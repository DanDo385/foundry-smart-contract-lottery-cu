// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract UpdateConfig is Script {
    function run() external {
        HelperConfig helperConfig = new HelperConfig();
        
        // Get your wallet address from the private key
        address yourWallet = vm.addr(vm.envUint("PRIVATE_KEY"));
        
        // Update Sepolia config with your subscription ID and wallet
        HelperConfig.NetworkConfig memory updatedConfig = HelperConfig.NetworkConfig({
            subscriptionId: 66519039676032633993506792433817181686460659372745633096502060897016332589906, // Your new subscription ID from recent deployment
            gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            automationUpdateInterval: 30,
            raffleEntranceFee: 0.01 ether,
            callbackGasLimit: 500000,
            vrfCoordinatorV2_5: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
            link: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
            account: yourWallet // Your actual wallet address
        });
        
        // Set the updated config
        helperConfig.setConfig(11155111, updatedConfig); // 11155111 is Sepolia chain ID
        
        console.log("Updated Sepolia config with:");
        console.log("Subscription ID:", updatedConfig.subscriptionId);
        console.log("Wallet address:", updatedConfig.account);
    }
}
