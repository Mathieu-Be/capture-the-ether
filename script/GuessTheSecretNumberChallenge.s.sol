// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/GuessTheSecretNumber.sol";

interface CaptureTheEther {
    function completeChallenge(uint256 index) external;
}

contract GuessTheSecretNumberScript is Script {
    address public constant GAME = 0x71c46Ed333C35e4E6c62D32dc7C8F00D125b4fee;
    address public constant CONTRACT =
        0x94c430079C88b4A4D83A7420139d9fe4EBDb1e8C;

    function run() external {
        bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        uint8 n;
        while (keccak256(abi.encodePacked(n)) != answerHash) {
            n++;
        }

        console.log("n: ", n);

        vm.broadcast(deployerPrivateKey);
        GuessTheSecretNumber(CONTRACT).guess{value: 1 ether}(n);

        vm.broadcast(deployerPrivateKey);
        CaptureTheEther(GAME).completeChallenge(4);
    }

    receive() external payable {}
}
