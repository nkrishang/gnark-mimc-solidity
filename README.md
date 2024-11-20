# gnark-mimc-solidity

- `src/MiMCHasher.sol`: Solidity implementation of [gnark-crypto](https://github.com/Consensys/gnark-crypto/) library's `mimc (Miyaguchi-Preneel) hash function.
- `test/MiMCTest.t.sol`: tests the output of gnark-crypto `mimc` against the output of the Solidity implementation.

> ⚠️ **Warning:** The Solidity implementation has NOT been audited.

The purpose of building this Solidity implementation is to verify proofs for ZK-SNARK circuits built using gnark, which use gnark's `mimc`.

## Usage

Clone the repository

```bash
git clone https://github.com/nkrishang/gnark-mimc-solidity.git
```

Install forge dependencies

```bash
forge install
```

Install go dependencies

```
go mod tidy
```

Run test

```
forge test
```

## Feedback

Please feel free to open an issue with any feedba!
