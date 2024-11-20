package merkle

import (
	"fmt"
	"math/big"
)

// Constants matching MerkleTreeWithHistory.sol
const MerkleTreeHeight = 20

// TreeNode represents a node in the merkle tree
type TreeNode struct {
	value *big.Int
}

// MerkleTree represents a fixed-height merkle tree
type MerkleTree struct {
	levels    int
	hashFunc  func(left, right *big.Int) *big.Int
	layers    [][]*TreeNode
	zeros     []*big.Int
	capacity  int
}

// ProofPath represents a merkle proof path
type ProofPath struct {
	PathElements []*big.Int
	PathIndices  []int
	PathRoot     *big.Int
}

// Pre-computed zero values matching your JS implementation
var ZeroValues = []*big.Int{
	hexToBigInt("2fe54c60d3acabf3343a35b6eba15db4821b340f76e741e2249685ed4899af6c"),
	hexToBigInt("256a6135777eee2fd26f54b8b7037a25439d5235caee224154186d2b8a52e31d"),
	hexToBigInt("1151949895e82ab19924de92c40a3d6f7bcb60d92b00504b8199613683f0c200"),
	hexToBigInt("20121ee811489ff8d61f09fb89e313f14959a0f28bb428a20dba6b0b068b3bdb"),
	hexToBigInt("0a89ca6ffa14cc462cfedb842c30ed221a50a3d6bf022a6a57dc82ab24c157c9"),
	hexToBigInt("24ca05c2b5cd42e890d6be94c68d0689f4f21c9cec9c0f13fe41d566dfb54959"),
	hexToBigInt("1ccb97c932565a92c60156bdba2d08f3bf1377464e025cee765679e604a7315c"),
	hexToBigInt("19156fbd7d1a8bf5cba8909367de1b624534ebab4f0f79e003bccdd1b182bdb4"),
	hexToBigInt("261af8c1f0912e465744641409f622d466c3920ac6e5ff37e36604cb11dfff80"),
	hexToBigInt("0058459724ff6ca5a1652fcbc3e82b93895cf08e975b19beab3f54c217d1c007"),
	hexToBigInt("1f04ef20dee48d39984d8eabe768a70eafa6310ad20849d4573c3c40c2ad1e30"),
	hexToBigInt("1bea3dec5dab51567ce7e200a30f7ba6d4276aeaa53e2686f962a46c66d511e5"),
	hexToBigInt("0ee0f941e2da4b9e31c3ca97a40d8fa9ce68d97c084177071b3cb46cd3372f0f"),
	hexToBigInt("1ca9503e8935884501bbaf20be14eb4c46b89772c97b96e3b2ebf3a36a948bbd"),
	hexToBigInt("133a80e30697cd55d8f7d4b0965b7be24057ba5dc3da898ee2187232446cb108"),
	hexToBigInt("13e6d8fc88839ed76e182c2a779af5b2c0da9dd18c90427a644f7e148a6253b6"),
	hexToBigInt("1eb16b057a477f4bc8f572ea6bee39561098f78f15bfb3699dcbb7bd8db61854"),
	hexToBigInt("0da2cb16a1ceaabf1c16b838f7a9e3f2a3a3088d9e0a6debaa748114620696ea"),
	hexToBigInt("24a3b3d822420b14b5d8cb6c28a574f01e98ea9e940551d2ebd75cee12649f9d"),
	hexToBigInt("198622acbd783d1b0d9064105b1fc8e4d8889de95c4c519b3f635809fe6afc05"),
}

// NewMerkleTree creates a new fixed-height merkle tree
func NewMerkleTree(levels int, leaves []*big.Int, hashFunc func(left, right *big.Int) *big.Int) (*MerkleTree, error) {
	capacity := 1 << levels
	if len(leaves) > capacity {
		return nil, fmt.Errorf("too many leaves for tree height")
	}

	tree := &MerkleTree{
		levels:    levels,
		hashFunc:  hashFunc,
		capacity:  capacity,
		zeros:     ZeroValues,
		layers:    make([][]*TreeNode, levels+1),
	}

	// Initialize the leaf layer
	tree.layers[0] = make([]*TreeNode, len(leaves))
	for i, leaf := range leaves {
		tree.layers[0][i] = &TreeNode{value: leaf}
	}

	// Build the tree
	tree.buildHashes()

	return tree, nil
}

// buildHashes builds all intermediate layers of the tree
func (m *MerkleTree) buildHashes() {
	for level := 1; level <= m.levels; level++ {
		prevNodes := m.layers[level-1]
		layerLen := (len(prevNodes) + 1) / 2
		currentLayer := make([]*TreeNode, layerLen)

		for i := 0; i < len(prevNodes); i += 2 {
			left := prevNodes[i].value
			var right *big.Int
			if i+1 < len(prevNodes) {
				right = prevNodes[i+1].value
			} else {
				right = m.zeros[level-1]
			}
			
			currentLayer[i/2] = &TreeNode{
				value: m.hashFunc(left, right),
			}
		}

		m.layers[level] = currentLayer
	}
}

// GetRoot returns the root of the merkle tree
func (m *MerkleTree) GetRoot() *big.Int {
	if len(m.layers[m.levels]) == 0 {
		return m.zeros[m.levels]
	}
	return m.layers[m.levels][0].value
}

// GetProof generates a merkle proof for a leaf at the given index
func (m *MerkleTree) GetProof(index int) (*ProofPath, error) {
	if index < 0 || index >= len(m.layers[0]) {
		return nil, fmt.Errorf("index out of bounds")
	}

	proof := &ProofPath{
		PathElements: make([]*big.Int, m.levels),
		PathIndices:  make([]int, m.levels),
		PathRoot:     m.GetRoot(),
	}

	for level := 0; level < m.levels; level++ {
		layerLen := len(m.layers[level])
		siblingIdx := index ^ 1 // XOR with 1 to get sibling index

		if siblingIdx < layerLen {
			proof.PathElements[level] = m.layers[level][siblingIdx].value
		} else {
			proof.PathElements[level] = m.zeros[level]
		}

		proof.PathIndices[level] = index % 2
		index = index / 2
	}

	return proof, nil
}

// Helper function to convert hex string to big.Int
func hexToBigInt(hex string) *big.Int {
	n := new(big.Int)
	n.SetString(hex, 16)
	return n
}