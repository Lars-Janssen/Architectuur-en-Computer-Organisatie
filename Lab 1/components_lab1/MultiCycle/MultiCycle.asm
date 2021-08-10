# Author: Wouter Koolen-Wijkstra
# This file contains the Mips Multicycle assembler instruction format definition
# this concerns partial syntax and full semantics


# first: machine information for the compiler

#targetComponent	"MultiCycle Mips Processor"
#targetMemory		"MultiCycle Mips Processor.Memory.Memory"
#targetStorage		"Storage"
#targetWordSize		0d32
#targetByteOrder	LSB


# second: the register constants

#define   $0   		0x0 
#define   $1    	0x1 
#define   $2    	0x2 
#define   $3    	0x3 
#define   $4    	0x4 
#define   $5    	0x5 
#define   $6    	0x6 
#define   $7    	0x7 
#define   $8    	0x8 
#define   $9    	0x9 
#define   $10   	0xA 
#define   $11    	0xB 
#define   $12    	0xC 
#define   $13    	0xD 
#define   $14    	0xE 
#define   $15    	0xF 
# #define   $16    	0x10 


# general idea
#
# OP:2 AUX:3 ALU:3 RS:4 RT:4 (RD:4 UNUSED:12 | IMM: 16)
#
# OP
# 0: Load-store
# 1: R-type
# 2: Conditional jump
# 3: Unconditional jump (can be executed faster than (2).


# third: instruction format and instruction definitions

#instructionformat   ARITH0  	OP:0d2, REGDEST:0d1, ALUSRCB:0d2, ALU:0d3, RS:0d4, RT:0d4, RD: 0d4, UNUSED:0d12 | rd:0d4
#instructiondefinition MAX		ARITH0 	" OP = 0b01; REGDEST=0b1; ALUSRCB = 0b00; ALU = 0x7; RS = 0; RT = 0; RD = rd; UNUSED = 0;"

#instructionformat   ARITH1  	OP:0d2, REGDEST:0d1, ALUSRCB:0d2, ALU:0d3, RS:0d4, RT:0d4, RD: 0d4, UNUSED:0d12 | rd:0d4, rt:04
#instructiondefinition NOT 		ARITH1 	" OP = 0b01; REGDEST = 0b1; ALUSRCB=0b00; ALU = 0x0; RS = 0; RT = rt; RD = rd; UNUSED = 0;"
#instructiondefinition TOO 		ARITH1	" OP = 0b01; REGDEST = 0b1; ALUSRCB=0b00; ALU = 0x1; RS = 0; RT = rt; RD = rd; UNUSED = 0;"

#instructionformat   ARITH2  	OP:0d2, REGDEST:0d1, ALUSRCB:0d2, ALU:0d3, RS:0d4, RT:0d4, RD: 0d4, UNUSED:0d12 | rd:0d4, rs:0d4, rt:04
#instructiondefinition SUB 		ARITH2	 " OP = 0b01; REGDEST = 0b1; ALUSRCB=0b00; ALU = 0x2; RS = rs; RT = rt; RD = rd; UNUSED = 0;"
#instructiondefinition ADD 		ARITH2	 " OP = 0b01; REGDEST = 0b1; ALUSRCB=0b00; ALU = 0x3; RS = rs; RT = rt; RD = rd; UNUSED = 0;"
#instructiondefinition XOR 		ARITH2	 " OP = 0b01; REGDEST = 0b1; ALUSRCB=0b00; ALU = 0x4; RS = rs; RT = rt; RD = rd; UNUSED = 0;"
#instructiondefinition OR 		ARITH2	 " OP = 0b01; REGDEST = 0b1; ALUSRCB=0b00; ALU = 0x5; RS = rs; RT = rt; RD = rd; UNUSED = 0;"
#instructiondefinition AND 		ARITH2	 " OP = 0b01; REGDEST = 0b1; ALUSRCB=0b00; ALU = 0x6; RS = rs; RT = rt; RD = rd; UNUSED = 0;"

#instructionformat   ARITHI1 	OP:0d2, REGDEST:0d1, ALUSRCB:0d2, ALU:0d3, RS:0d4, RT:0d4, IMM:0d16 | rt:0d4, imm:0d16
#instructiondefinition NOTI		ARITHI1 " OP = 0b01; REGDEST = 0b0; ALUSRCB=0b10; ALU = 0x0; RS = 0; RT = rt; IMM = imm;"
#instructiondefinition TOOI		ARITHI1	" OP = 0b01; REGDEST = 0b0; ALUSRCB=0b10; ALU = 0x1; RS = 0; RT = rt; IMM = imm;"
#instructiondefinition LI		ARITHI1	" OP = 0b01; REGDEST = 0b0; ALUSRCB=0b10; ALU = 0x1; RS = 0; RT = rt; IMM = imm;"

#instructionformat   ARITHI2 	OP:0d2, REGDEST:0d1, ALUSRCB:0d2, ALU:0d3, RS:0d4, RT:0d4, IMM:0d16 | rt:0d4, rs:0d4, imm:0d16
#instructiondefinition SUBI		ARITHI2	 " OP = 0b01; REGDEST = 0b0; ALUSRCB=0b10; ALU = 0x2; RS = rs; RT = rt; IMM = imm;"
#instructiondefinition ADDI		ARITHI2	 " OP = 0b01; REGDEST = 0b0; ALUSRCB=0b10; ALU = 0x3; RS = rs; RT = rt; IMM = imm;"
#instructiondefinition XORI		ARITHI2	 " OP = 0b01; REGDEST = 0b0; ALUSRCB=0b10; ALU = 0x4; RS = rs; RT = rt; IMM = imm;"
#instructiondefinition ORI		ARITHI2	 " OP = 0b01; REGDEST = 0b0; ALUSRCB=0b10; ALU = 0x5; RS = rs; RT = rt; IMM = imm;"
#instructiondefinition ANDI		ARITHI2	 " OP = 0b01; REGDEST = 0b0; ALUSRCB=0b10; ALU = 0x6; RS = rs; RT = rt; IMM = imm;"

# Alas, the compiler does not handle absolute adresses
# We implement the unconditional jump as a conditional one 
# with the condition that register zero equals itself.
# #instructionformat   BRANCH0 	OP:0d2, OFFS:0d30 | offs:0d30
# #instructiondefinition J		BRANCH0	 "OP = 0b11; OFFS = offs;"

#instructionformat   BRANCH0 	OP:0d2, AUX:0d3, ALU:0d3, RS:0d4, RT:0d4, OFFS:0d16 | offs:0d16
#instructiondefinition J 		BRANCH0	 "OP = 0b10; AUX = 0b110; ALU = 0x2; RS = 0; RT = 0;  OFFS = offs-1;"


#instructionformat   BRANCH1 	OP:0d2, AUX:0d3, ALU:0d3, RS:0d4, RT:0d4, OFFS:0d16 | rt:0d4, offs:0d16
#instructiondefinition BZ 		BRANCH1	 "OP = 0b10; AUX = 0b110; ALU = 0x1; RS = 0; RT = rt;  OFFS = offs-1;"

#instructionformat   BRANCH2 	OP:0d2, AUX:0d3, ALU:0d3, RS:0d4, RT:0d4, OFFS:0d16 | rt:0d4, rs:0d4, offs:0d16
#instructiondefinition BEQ 		BRANCH2	 "OP = 0b10; AUX = 0b110; ALU = 0x2;  RS = rs; RT = rt; OFFS = offs-1;"

#instructionformat   LOADSTORE 	OP:0d2, AUX:0d3, ALU:0d3, RS:0d4, RT:0d4, OFFS:0d16 | rt:0d4, offs:0d16, rs:0d4
#instructiondefinition LW 		LOADSTORE	 "OP = 0b00; AUX = 0b000; ALU=0x3; RS = rs; RT = rt; OFFS = offs;"
#instructiondefinition SW 		LOADSTORE	 "OP = 0b00; AUX = 0b001; ALU=0x3; RS = rs; RT = rt; OFFS = offs;"
