# Conway’s Game of Life

<img src="./img/metapixel.gif" width="75%"/>

## Overview

Conway’s Game of Life is a two-dimensional zero-player game, invented by mathematician John Horton Conway in 1970. The objective is to observe the evolution of a system of cells based on an initial configuration, following rules that dictate the death or creation of new cells. This system is Turing-complete.

The system’s state is described by the state of individual cells, governed by the following rules:

- **Underpopulation**: A live cell with fewer than two live neighbors dies in the next generation.

- **Survival**: A live cell with two or three live neighbors survives to the next generation.

- **Overpopulation**: A live cell with more than three live neighbors dies in the next generation.

- **Creation**: A dead cell with exactly three live neighbors becomes alive in the next generation.

- **Stasis**: Any dead cell not satisfying the creation rule remains dead.

**The 8 neighbors of a cell are considered as follows in a 2D matrix:**

```R
00   01   02
10   cell 12
20   21   22
```

We define the system state at generation n as a matrix Sn ∈ M(m×n)({0, 1}), where m is the number of rows, n is the number of columns, 0 represents a dead cell, and 1 represents a live cell. A k-evolution (k ≥ 0) is an iteration S₀ → S₁ → ... → Sₖ, where each Sᵢ+1 is obtained from Sᵢ by applying the rules described above.

For cells on the edges of the matrix (first/last rows or columns), the system is extended by treating cells outside the matrix as dead.

## Example

Given the initial configuration S₀:

```R
0 1 1 0
1 0 0 0
0 0 1 1
```

We first extend the matrix to a 5x6 grid, treating the outer cells as dead:

```R
0 0 0 0 0 0
0 0 1 1 0 0
0 1 0 0 0 0
0 0 0 1 1 0
0 0 0 0 0 0
```

Following the rules, we compute the next generation S₁ as:

```R
0 0 0 0 0 0
0 0 1 0 0 0
0 0 0 0 1 0
0 0 0 0 0 0
0 0 0 0 0 0
```

## Symmetric Encryption Scheme

<img src="./img/encrypt.gif" width="75%"/>
<hr>
We define an encryption key, starting from an initial configuration S₀ and applying a k-evolution, as the operation <S₀, k>. This produces a one-dimensional data array (bit string) by concatenating the rows of the extended matrix Sₖ.

For instance, starting with S₀ and applying a 1-evolution, we obtain the extended matrix S₁, which gives the following bit string:

```R
000000001000000010000000000000
```

Given a plaintext message m (a string without spaces), encryption {m} <S₀, k> involves XOR-ing the message with the result of <S₀, k>. The cases are:

- If the message and key are the same length, XOR each element.
- If the message is shorter, use the corresponding portion of the key.
- If the message is longer, repeat the key as many times as needed.
<hr>
Let m = "parola" (password) and the key be <S₀, 1>. The bit string is:

```R
000000001000000010000000000000
```

The binary ASCII encoding of "parola" is:

```R
p 01110000
a 01100001
r 01110010
o 01101111
l 01101100
a 01100001
```

Thus, "parola" becomes:

```R
011100000110000101110010011011110110110001100001
```

Since the message is longer than the key, we repeat the key:

```R
mesaj = 011100000110000101110010011011110110110001100001
cheie = 000000001000000010000000000000
```

XOR-ing gives the encrypted message:

```R
encrypted = 011100001110000111110010011011110110111001100011
```

In hexadecimal, the result is:

```R
0x70E1F26F6E63
```

For decryption, the same XOR process is applied, using the key to recover the original message.
