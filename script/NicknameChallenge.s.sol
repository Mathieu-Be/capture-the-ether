// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface CaptureTheEther {
    function completeChallenge(uint256 index) external;
}

interface NicknameChallenge {
    function setNickname(bytes32 nickname) external;
}

contract NicknameChallengeScript is Script {
    address public constant GAME = 0x71c46Ed333C35e4E6c62D32dc7C8F00D125b4fee;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.broadcast(deployerPrivateKey);
        NicknameChallenge(GAME).setNickname("Patate");

        vm.broadcast(deployerPrivateKey);
        CaptureTheEther(GAME).completeChallenge(2);
    }
}
