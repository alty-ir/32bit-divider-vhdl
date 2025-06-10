# 32-bit VHDL Divider Implementation Report

## Overview

This document describes the implementation of a 32-bit divider using VHDL. The divider is designed to perform division operations on 32-bit numbers using a state machine-based approach with sequential logic.

## Technical Specifications

- Input A: 32-bit dividend (STD_LOGIC_VECTOR)
- Input B: 16-bit divisor (STD_LOGIC_VECTOR)
- Output Q: 16-bit quotient (outQ)
- Output R: 16-bit remainder (baghimande)
- Clock input: Standard clock signal
- Control signals: Start and Done

## Architecture

The divider is implemented using a Finite State Machine (FSM) with 5 states:
- S0: Initial state
- S1: Load sum state
- S2: Shift left with 0
- S3: Shift left with 1
- S4: Completion check state

### Key Components

1. **State Machine**
   - 5-state FSM controls the division operation
   - States handle different phases of the division algorithm
   - Transition logic based on comparison results

2. **Registers**
   - tempA: 32-bit register for dividend manipulation
   - tempB: 16-bit register for divisor storage
   - SC: 5-bit counter for operation tracking

3. **Control Signals**
   - cnt: Counter enable
   - loadSum: Sum loading control
   - ShiftLeft0/ShiftLeft1: Shift operation controls

### Signal Processing

```vhdl
Signal tempA : STD_LOGIC_VECTOR (31 downto 0);
Signal tempB : STD_LOGIC_VECTOR (15 downto 0);
Signal tempAA : STD_LOGIC_VECTOR (31 downto 0);
Signal tempBB : STD_LOGIC_VECTOR (15 downto 0);
Signal sum : STD_LOGIC_VECTOR (15 downto 0);
```

## Algorithm Implementation

The division algorithm follows these steps:

1. **Initialization**
   - Load the dividend and divisor
   - Handle sign bits for negative numbers
   - Initialize control registers

2. **Division Process**
   - Perform sequential subtraction and shift operations
   - Track intermediate results in tempA register
   - Update quotient bits based on comparison results

3. **Result Generation**
   - Calculate final quotient and remainder
   - Handle sign adjustments for negative numbers
   - Output results when done signal is asserted

### Sign Handling

The implementation includes special handling for negative numbers:
```vhdl
if A(31) = '0' then
    tempA <= A(30 downto 0) & '0';
else
    tempAAA <= not A + 1;
    tempA <= tempAAA(30 downto 0) & '0';
end if;
```

## Testing and Verification

The design includes three testbenches:
1. `test.vhd`: Basic functionality testing
2. `tb_phase2.vhd`: Phase 2 verification
3. `teeest.vhd`: Additional test cases

### Test Cases Include:
- Positive number division
- Negative number handling
- Boundary conditions
- Timing verification

## Performance Characteristics

- Clock Period: 10ns
- Maximum Frequency: 100MHz
- Latency: Variable based on input values
- Completion indicated by Done signal

## Synthesis Results

The design has been synthesized using Xilinx ISE with the following target:
- Device: Virtex-7
- Package: ffg1157
- Speed Grade: -1

## Future Improvements

Potential areas for enhancement:
1. Pipeline implementation for higher throughput
2. Optimization of the state machine
3. Additional error handling
4. Clock gating for power optimization
