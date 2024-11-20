package main

import (
	"fmt"
	"math/big"

	"github.com/nkrishang/go-fixed-merkle-tree/go/merkle"
)

// mockMiMCHash is a simplified hash function for demonstration
// Replace this with your actual MiMC implementation
func mockMiMCHash(left, right *big.Int) *big.Int {
	// This is just for demonstration - not cryptographically secure!
	result := new(big.Int)
	result.Add(left, right)
	result.Mul(result, big.NewInt(2))
	return result
}

func printProof(proof *merkle.ProofPath) {
	fmt.Println("\nMerkle Proof:")
	fmt.Printf("Root: %s\n", proof.PathRoot.Text(16))
	
	fmt.Println("\nPath Elements:")
	for i, element := range proof.PathElements {
		fmt.Printf("Level %d: %s (direction: %d)\n", 
			i, 
			element.Text(16), 
			proof.PathIndices[i])
	}
}

// verifyProof verifies a merkle proof
// This matches the verification logic in your smart contract
func verifyProof(leaf *big.Int, proof *merkle.ProofPath, hashFunc func(*big.Int, *big.Int) *big.Int) bool {
	currentHash := new(big.Int).Set(leaf)

	for i, sibling := range proof.PathElements {
		if proof.PathIndices[i] == 0 {
			currentHash = hashFunc(currentHash, sibling)
		} else {
			currentHash = hashFunc(sibling, currentHash)
		}
	}

	return currentHash.Cmp(proof.PathRoot) == 0
}

// hexToBigInt converts a hex string to big.Int
func hexToBigInt(hex string) *big.Int {
	n := new(big.Int)
	n.SetString(hex, 16)
	return n
}

func main() {
	// Create some sample leaves (in hex format to match your JS version)
	leaves := []*big.Int{
		hexToBigInt("1234567890123456789012345678901234567890"),
		hexToBigInt("2234567890123456789012345678901234567890"),
		hexToBigInt("3234567890123456789012345678901234567890"),
		hexToBigInt("4234567890123456789012345678901234567890"),
	}

	// Create new tree
	tree, err := merkle.NewMerkleTree(merkle.MerkleTreeHeight, leaves, mockMiMCHash)
	if err != nil {
		panic(fmt.Sprintf("Failed to create merkle tree: %v", err))
	}

	// Get and print the root
	root := tree.GetRoot()
	fmt.Printf("Tree Root: %s\n", root.Text(16))

	// Generate and print proof for each leaf
	for i, leaf := range leaves {
		proof, err := tree.GetProof(i)
		if err != nil {
			panic(fmt.Sprintf("Failed to generate proof: %v", err))
		}

		fmt.Printf("\n=== Proof for leaf %d (%s) ===\n", i, leaf.Text(16))
		printProof(proof)
	}

	// Demonstrate verifying a proof
	// This would typically be done by your smart contract
	fmt.Println("\n=== Verifying Proofs ===")
	firstLeafProof, _ := tree.GetProof(0)
	verified := verifyProof(leaves[0], firstLeafProof, mockMiMCHash)
	fmt.Printf("Proof verification for leaf 0: %v\n", verified)
}