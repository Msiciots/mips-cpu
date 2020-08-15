# MIPS CPU
A pipelined MIPS CPU implemented in Verilog. And verified by Modelsim. 

Figure 1. shows the CPU datapath. The pipelined CPU has five stages: 
- IF: instruction fetch
- ID: instruction decode and register file read
- EX: execution and address calculation
- MEM: memory access
- WB: write back 
<center>
<img src="https://i.imgur.com/PiTkZlS.png">

Figure 1. The CPU datapath</center><p>  </p>

There are four pipeline registers (IF_ID, ID_EX, EX_M and M_WB) between the five stages. These pipeline registers can store the data & control signals of the instructions and pass the information from one stage to next stage. These modules are sequential circuits and they are triggered by negative clock edges. The program counter is stored in the PC module and also triggered by negative clock edges. Figure 2. shows the clock trigger.  
<center>
<img src="https://i.imgur.com/8NCZpjw.png" width="50%">

Figure 2. The CPU clock trigger</center><p>  </p>

The instruction and data memory are IM and DM modules. Both of these modules are triggered by positive clock edges.

The data hazard and control hazard problems are handled by the hazard detection unit (HDU) and forwarding unit (FU). Both of these hazards are solved by stalling. And the branch predictions are always not taken.

## Support instruction
### R-type Instruction
**Assembler syntax**
| instruction | rd | rs |rt|
| -------- | -------- | -------- | --------|

**Machine code format**

| opcode | rs | rt |rd|shamt|funct|
| -------- | -------- | -------- | --------|--------|--------|

**Instruction list**

| Opcode | Mnemonics | SRC1 |SRC2|DST|funct|Description|
| -------- | -------- | -------- | --------|--------|--------|--------|
|000000|nop|00000|00000|00000|000000|No operation|
|000000|add|$Rs| $Rt| $Rd| 100000| Rd = Rs + Rt|
|000000|sub|$Rs| $Rt| $Rd| 100010| Rd = Rs – Rt|
|000000|and|$Rs| $Rt| $Rd| 100100| Rd = Rs & Rt|
|000000|or |$Rs| $Rt| $Rd| 100101| Rd = Rs | Rt|
|000000|xor|$Rs| $Rt| $Rd| 100110| Rd = Rs ^ Rt|
|000000|nor|$Rs| $Rt| $Rd| 100111| Rd = ~(Rs | Rt)|
|000000|slt|$Rs| $Rt| $Rd| 101010| Rd = ( Rs < Rt )?1:0|
|000000|sll|   | $Rt| $Rd| 000000|Rd = Rt << shamt|
|000000|srl|   | $Rt| $Rd| 000010| Rd = Rt >> shamt|
|000000|jr |$Rs|    |    | 001000| PC = Rs|
|000000|jalr|$Rs|   |    | 001001| R[31] = PC+8;  PC = Rs|
### I-type Instruction
**Assembler syntax**
| instruction | rt | rs |imm|
| -------- | -------- | -------- | --------|

**Machine code format**

| opcode | rs | rt |immediate|
| -------- | -------- | -------- | --------|

**Instruction list**

| Opcode | Mnemonics | SRC1 |DST|SRC2|Description|
| -------- | -------- | -------- | --------|--------|--------|
|001000|addi|$Rs| $Rt| imm|Rt = Rs + imm0|
|001100|andi|$Rs| $Rt| imm|Rt = Rs & imm| 
|001010|slti|$Rs| $Rt| imm|Rt = ( Rs < imm ) ? 1 : 0| 
|000100|beq |$Rs| $Rt| imm|If( Rs == Rt) PC=PC+4+imm|
|000101|bne |$Rs| $Rt| imm|If( Rs != Rt) PC=PC+4+imm| 
|100011|lw  |$Rs| $Rt| imm|Rt = Mem[ Rs + imm ]| 
|100001|lh  |$Rs| $Rt| imm|Data = Mem[ Rs + imm ];  Rt = data[15:0] <- Sign-extend 16bits| 
|101011|sw  |$Rs| $Rt| imm| Mem[ Rs + imm ] = Rt| 
|101001|sh  |$Rs| $Rt| imm| Data <- Rt[15:0] Sign-extend 16bits;    Mem[ Rs + imm ] = Rt|
### J-type Instruction
**Assembler syntax**
| instruction | target(label)|
| -------- | -------- | 

**Machine code format**

| opcode | address|
| -------- | -------- | 

**Instruction list**
| Opcode | Mnemonics | Address |Description|
| -------- | -------- | -------- | --------|
|000010|j  |jumpAddr| PC = jumpAddr| 
|000011|jal|jumpAddr| R[31] = PC + 8 ; PC = jumpAddr| 

## Verification
Run testfixture1.v to verify the CPU. The executed instructions are stored at "/tb1/IM_data.dat". And the calculation results are compared to "/tb1/golden_DM.dat"

### Forwarding
31: sll $s0, $s0, 1 # $s0 = 32767 * 2 = 65534  
32: addi $s0, $s0, 1 # $s0 = 65535 
![](https://i.imgur.com/1EkzH3I.png)

### Load Stall
37: lw $s0, 40($a0) # $s0 = 65535  
37-2: add $s0, $s0, $0 # $s0 = 65535  
**To stall:**  
PC_Write = 0   
IF_IDWrite = 0     
![](https://i.imgur.com/nr2infD.png)

### Branch Stall
fun3: bne $8, $0, 0 [fun4-0x004000d8]; Jump to fun4   
After a branch detection, IF_ID flush.
![](https://i.imgur.com/rAKfRvY.png)

## Reference

David Patterson, & John Hennessy (2013). *Computer Organization and Design MIPS Edition: The Hardware/Software Interface* (5th ed.). Morgan Kaufmann.
