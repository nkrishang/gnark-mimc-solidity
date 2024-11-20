// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract MiMCHasher {
    uint256 private constant MIMC_ROUNDS = 110;
    uint256 private constant FIELD_SIZE = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    
    uint256[MIMC_ROUNDS] private roundConstants;
    bool private constant_initialized;
    
    constructor() {
        if (!constant_initialized) {
            // Exactly match gnark's constant generation:
            // hash := sha3.NewLegacyKeccak256()
            // _, _ = hash.Write(bseed)
            // rnd := hash.Sum(nil) // pre hash before use
            // hash.Reset()
            // _, _ = hash.Write(rnd)
            bytes32 rnd = keccak256(abi.encodePacked("seed"));
            bytes32 currentHash = keccak256(abi.encodePacked(rnd));
            
            for (uint256 i = 0; i < MIMC_ROUNDS; i++) {
                roundConstants[i] = uint256(currentHash) % FIELD_SIZE;
                currentHash = keccak256(abi.encodePacked(currentHash));
            }
            constant_initialized = true;
        }
    }

    // Matches gnark's encrypt function exactly
    function encrypt(uint256 m, uint256 h) internal view returns (uint256) {
        uint256 tmp;
        
        for (uint256 i = 0; i < MIMC_ROUNDS; i++) {
            // tmp = m + h + c
            tmp = addmod(addmod(m, h, FIELD_SIZE), roundConstants[i], FIELD_SIZE);
            
            // m = tmp^5
            m = mulmod(tmp, tmp, FIELD_SIZE);  // tmp^2
            m = mulmod(m, m, FIELD_SIZE);      // tmp^4
            m = mulmod(m, tmp, FIELD_SIZE);    // tmp^5
        }
        
        return addmod(m, h, FIELD_SIZE);
    }

    // Implements gnark's Miyaguchi-Preneel construction exactly
    function hash(uint256[] calldata data) public view returns (uint256) {
        uint256 h = 0;
        
        // Match gnark's checksum implementation
        for (uint256 i = 0; i < data.length; i++) {
            uint256 r = encrypt(data[i], h);
            // h = encrypt(m, h) + h + m
            h = addmod(addmod(r, h, FIELD_SIZE), data[i], FIELD_SIZE);
        }
        
        return h;
    }
}