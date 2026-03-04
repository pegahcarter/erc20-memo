// SPDX-License-Identifier: ISC
pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import { ERC20MemoString } from "../contracts/ERC20MemoString.sol";

// This is a free function that can be imported and used in tests or other scripts
function deployERC20MemoString() returns (address _address) {
    ERC20MemoString _ERC20MemoString = new ERC20MemoString();
    _address = address(_ERC20MemoString);
}

// Run this with source .env && forge script --broadcast --rpc-url $MAINNET_URL DeployERC20MemoString.s.sol
contract DeployERC20MemoString is Script {
    function run() public {
        vm.startBroadcast();
        address addr = deployERC20MemoString();
        ERC20MemoString erc20 = ERC20MemoString(addr);

        address to = address(1);
        string memory memo = "Buy frxUSD";
        bytes32 memoHash = keccak256(abi.encodePacked(memo));
        uint256 amount = 100e18;

        // Example 1: Call the transferWithMemo function where memo is a simple string
        erc20.transferWithMemo(to, amount, memo);

        // Example 2: call the transferWithMemo function where memo is a bytes32 hash
        erc20.transferWithMemo(to, amount, memoHash);

        // Example 3: call transfer with appending the bytes of the memo to the end of the data field
        bytes memory callData = bytes.concat(
            abi.encodeWithSignature("transfer(address,uint256)", to, amount),
            abi.encodePacked(memo)
        );
        (bool success, ) = addr.call(callData);
        require(success, "Transfer with memo failed");

        vm.stopBroadcast();
    }
}
