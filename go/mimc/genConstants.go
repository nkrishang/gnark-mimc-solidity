package main

import (
	"encoding/hex"
	"fmt"
	"math/big"

	"golang.org/x/crypto/sha3"
)

const (
	mimcNbRounds = 110
	seed         = "seed"
)

// BN254 field modulus
var fieldModulus, _ = new(big.Int).SetString("21888242871839275222246405745257275088548364400416034343698204186575808495617", 10)

func main() {
	// Initialize constants following gnark's method
	bseed := []byte(seed)

	// Create keccak256 hash
	hash := sha3.NewLegacyKeccak256()
	
	// First hash of seed
	hash.Write(bseed)
	rnd := hash.Sum(nil)
	hash.Reset()
	
	// Second hash (matches gnark's implementation)
	hash.Write(rnd)

	// Generate individual constants
	fmt.Println("// Individual round constants")
	for i := 0; i < mimcNbRounds; i++ {
		rnd = hash.Sum(nil)
		
		// Convert to big.Int and mod by field size
		constant := new(big.Int).SetBytes(rnd)
		constant.Mod(constant, fieldModulus)
		
		// Format as individual constant declaration
		fmt.Printf("    uint256 private constant ROUND_CONSTANT_%d = 0x%064s;\n", 
			i+1, 
			hex.EncodeToString(constant.Bytes()))
		
		// Reset and write previous result for next round
		hash.Reset()
		hash.Write(rnd)
	}

	// Generate getter function
	fmt.Println("\n    // Getter function for round constants")
	fmt.Printf("    function getRoundConstants() internal pure returns (uint256[] memory const) {\n")
	fmt.Printf("        const = new uint256[](%d);\n\n", mimcNbRounds)
	
	// Add all constants to array
	for i := 0; i < mimcNbRounds; i++ {
		fmt.Printf("        const[%d] = ROUND_CONSTANT_%d;\n", i, i+1)
	}
	
	fmt.Println("\n        return const;")
	fmt.Println("    }")
}