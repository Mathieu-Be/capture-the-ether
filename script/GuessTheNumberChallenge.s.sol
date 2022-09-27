// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/GuessTheNumber.sol";

interface CaptureTheEther {
    function completeChallenge(uint256 index) external;
}

contract GuessTheNumberScript is Script {
    address public constant GAME = 0x71c46Ed333C35e4E6c62D32dc7C8F00D125b4fee;
    address public constant CONTRACT =
        0x84cB699B29f52E86e5E26654ECd15dBa2d1c3767;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.broadcast(deployerPrivateKey);
        GuessTheNumber(CONTRACT).guess{value: 1 ether}(42);

        vm.broadcast(deployerPrivateKey);
        CaptureTheEther(GAME).completeChallenge(3);
    }

    receive() external payable {}
}
