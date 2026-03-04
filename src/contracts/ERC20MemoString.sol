// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20MemoString is ERC20 {
    event TransferWithMemo(
        address indexed from,
        address indexed to,
        uint256 value,
        bytes32 indexed memoHash,
        string memo
    );

    constructor() ERC20("ERC20MemoString", "MEMO") {
        _mint(msg.sender, 1000e18);
    }

    function transferWithMemo(address to, uint256 amount, string memory memo) external returns (bool) {
        _transfer(msg.sender, to, amount);
        bytes32 memoHash = keccak256(abi.encodePacked(memo));
        emit TransferWithMemo(msg.sender, to, amount, memoHash, memo);
        return true;
    }

    function transferWithMemo(address to, uint256 amount, bytes32 memoHash) external returns (bool) {
        _transfer(msg.sender, to, amount);
        emit TransferWithMemo(msg.sender, to, amount, memoHash, "");
        return true;
    }
}
