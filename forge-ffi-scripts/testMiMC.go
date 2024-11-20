package main

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"math/big"

	"github.com/consensys/gnark-crypto/ecc/bn254/fr"
	"github.com/consensys/gnark-crypto/ecc/bn254/fr/mimc"
	"github.com/ethereum/go-ethereum/accounts/abi"
)

var fieldSize, _ = new(big.Int).SetString("21888242871839275222246405745257275088548364400416034343698204186575808495617", 10)

func RandomBigInt() (*big.Int) {
	v, _ := rand.Int(rand.Reader, fieldSize) 
	return v
}

// ComputeMiMCHash computes a MiMC hash of the input values
func ComputeMiMCHash(inputs []*big.Int) (*big.Int, error) {
    hasher := mimc.NewMiMC()
    
    for _, input := range inputs {
        if input == nil {
            return nil, fmt.Errorf("input is nil")
        }
        var element fr.Element
        element.SetBigInt(input)
        bytes := element.Bytes()
        hasher.Write(bytes[:])
    }
    
    var result fr.Element
    result.SetBytes(hasher.Sum(nil))
    
    // Create a new big.Int to store the result
    bigIntResult := new(big.Int)
    result.BigInt(bigIntResult)
    return bigIntResult, nil
}

func main() {
	// Generate two test inputs
	xElem := RandomBigInt()
	yElem := RandomBigInt()

	// Verify values are less than field size
	if xElem.Cmp(fieldSize) >= 0 || yElem.Cmp(fieldSize) >= 0 {
		panic("inputs must be less than field size")
	}

	// Hash the two inputs using gnark's MP construction
	inputs := []*big.Int{xElem, yElem}
	result, err := ComputeMiMCHash(inputs)
	if err != nil {
		panic(err)
	}
	
	// Convert to bytes32
	resultBytes := result.Bytes()
	var resultBytes32 [32]byte
	copy(resultBytes32[:], resultBytes[:])

	// Prepare for ABI encoding
	uint256Ty, _ := abi.NewType("uint256", "", nil)
	bytes32Ty, _ := abi.NewType("bytes32", "", nil)

	args := abi.Arguments{
		{Type: uint256Ty},
		{Type: uint256Ty},
		{Type: bytes32Ty},
	}

	// Pack values for Forge test
	encoded, err := args.Pack(&xElem, &yElem, resultBytes32)
	if err != nil {
		panic(err)
	}

	fmt.Print(hex.EncodeToString(encoded))
}