# **Conway’s Game of Life & Symmetric Encryption**  

<img src="./img/metapixel.gif" width="75%"/>

## **📌 Overview**  

**Conway’s Game of Life** is a two-dimensional, zero-player game invented by mathematician **John Horton Conway** in 1970. The system evolves based on a set of predefined rules, determining the survival, death, or creation of cells over multiple generations. This model is **Turing-complete**, meaning it can simulate any computational system.

Additionally, we define a **symmetric encryption scheme** based on Conway's Game of Life, where a key is derived from the evolution of an initial configuration, transforming it into a bit string for secure encryption.


## **🌱 Game Rules**  

Each cell in the system follows these fundamental rules:  

✔ **Underpopulation** – A live cell with **fewer than two** live neighbors dies.  
✔ **Survival** – A live cell with **two or three** live neighbors survives.  
✔ **Overpopulation** – A live cell with **more than three** live neighbors dies.  
✔ **Creation** – A dead cell with **exactly three** live neighbors becomes alive.  
✔ **Stasis** – Any dead cell **not satisfying** the creation rule remains dead.  

**Cell neighbors are defined as follows in a 2D matrix:**  

```R
00   01   02
10   cell 12
20   21   22
```

The system state at generation **n** is represented as a matrix **Sₙ ∈ M(m×n)({0, 1})**, where:  
- **m** = number of rows  
- **n** = number of columns  
- **0** = dead cell  
- **1** = live cell  

A **k-evolution** (k ≥ 0) is an iteration sequence **S₀ → S₁ → ... → Sₖ**, where each state **Sᵢ+1** is derived from **Sᵢ** based on the game rules.

For **edge cells** (border of the matrix), we assume cells **outside the matrix are dead**.


## **🔍 Example**  

### **Initial Configuration S₀:**  

```R
0 1 1 0
1 0 0 0
0 0 1 1
```

We first **extend the matrix** (adding a border of dead cells):  

```R
0 0 0 0 0 0
0 0 1 1 0 0
0 1 0 0 0 0
0 0 0 1 1 0
0 0 0 0 0 0
```

Applying the **Game of Life rules**, the next generation **S₁** is:  

```R
0 0 0 0 0 0
0 0 1 0 0 0
0 0 0 0 1 0
0 0 0 0 0 0
0 0 0 0 0 0
```


## **🔐 Symmetric Encryption Scheme**  

<img src="./img/encrypt.gif" width="75%"/>
<hr>

We define an **encryption key** using an initial configuration **S₀** and applying a **k-evolution**. The resulting matrix **Sₖ** is transformed into a **bit string** by concatenating its rows.

### **🔑 Key Generation Process**  

1️⃣ Start with an **initial configuration S₀**  
2️⃣ Apply **k-evolutions** to generate **Sₖ**  
3️⃣ Convert **Sₖ** into a **bit string** (by row-wise concatenation)  

For example, with **S₀** and **k = 1**, the extended matrix **S₁** generates the bit string:  

```R
000000001000000010000000000000
```

### **📌 Encryption Process**  

Given a **plaintext message** `m` (string without spaces), we **XOR** it with the bit string generated from **S₀, k**.  

Rules:  
✔ If `m` and the key are the **same length**, XOR each bit.  
✔ If `m` is **shorter**, use only the corresponding part of the key.  
✔ If `m` is **longer**, repeat the key until fully covered.  

#### **Example: Encrypting "parola"**  

1️⃣ Convert **message** "parola" to **binary ASCII**:  

```R
p 01110000
a 01100001
r 01110010
o 01101111
l 01101100
a 01100001
```

Concatenated:  

```R
011100000110000101110010011011110110110001100001
```

2️⃣ **Repeat key** to match message length:  

```R
message = 011100000110000101110010011011110110110001100001
key     = 000000001000000010000000000000
```

3️⃣ **XOR** message with key:  

```R
encrypted = 011100001110000111110010011011110110111001100011
```

4️⃣ Convert **to hexadecimal**:  

```R
0x70E1F26F6E63
```

### **📌 Decryption Process**  

Decryption follows the same **XOR operation** with the **same key**, recovering the **original message**.

