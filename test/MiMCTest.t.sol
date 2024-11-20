// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MiMCHasher} from "src/MiMCHasher.sol";

interface IMiMCHasher {
    function hash(uint256[] calldata data) external view returns (uint256);
}

contract MiMCTest is Test {

    uint256 internal constant FIELD_SIZE = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

    MiMCHasher public hasher;

    function setUp() public {
        hasher = new MiMCHasher();
    }

    function hashLeftRight(bytes32 _left, bytes32 _right) public view returns (bytes32) {
        require(uint256(_left) < FIELD_SIZE, "_left should be inside the field");
        require(uint256(_right) < FIELD_SIZE, "_right should be inside the field");
        
        // Simply use our M-P hash with two inputs
        uint256[] memory inputs = new uint256[](2);
        inputs[0] = uint256(_left);
        inputs[1] = uint256(_right);
        return bytes32(hasher.hash(inputs));
    }

    function test_mimc() public {
        // Get x, y and gnark implementation hashLeftRight(x,y) value.
        string[] memory inputs = new string[](4);
        inputs[0] = "go";
        inputs[1] = "run";
        inputs[2] = "forge-ffi-scripts/testMiMC.go";

        bytes memory result = vm.ffi(inputs);
        (uint256 x, uint256 y, bytes32 res) = abi.decode(result, (uint256, uint256, bytes32));

        // Get Solidity implementation hash value.
        bytes32 h = hashLeftRight(bytes32(x), bytes32(y));

        assertEq(h, res);
    }
}