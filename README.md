# 8x8 Bit Sequential Multiplier

The 8x8 Bit Sequential Multiplier is a Verilog design that implements an 8x8 bit multiplier using a sequential approach. This project aims to provide an efficient and modular solution for performing multiplication operations on 8-bit operands, resulting in a 16-bit product. The design supports various features, including multi-cycle computation, output signaling, and efficient pin utilization.

## Specification

The project's goal is to build an 8x8 multiplier that takes two 8-bit multiplicands (`dataa` and `datab`) as inputs and produces a 16-bit product (`product8x8_out`). Additionally, the design provides a done flag (`done_flag`) and seven signals (`seg_a`, `seg_b`, `seg_c`, `seg_d`, `seg_e`, `seg_f`, and `seg_g`) to drive a 7-segment display. The multiplier operates in a multi-cycle fashion, requiring four clock cycles to complete the full multiplication.

## Functionality

The multiplier utilizes a sequential approach to perform the multiplication operation. During each of the four clock cycles, a pair of 4-bit slices from `dataa` and `datab` is multiplied by a 4x4 multiplier. The resulting 4-bit slices are then accumulated to obtain the final 16-bit product. On the fifth cycle, the fully composed 16-bit product is available at the output (`product8x8_out`).

## Mathematical Principle

The multiplier's functionality is based on the mathematical principles of multiplication. It breaks down the 8-bit multiplicands `a` and `b` into 4-bit slices and performs partial multiplications. The final 16-bit product is obtained by summing the individual partial products according to the following equation:

result[15..0] = a[7..0] * b[7..0]
= ((a[7..4] * 2^4) + a[3..0] * 2^0) * ((b[7..4] * 2^4) + b[3..0] * 2^0)
= ((a[7..4] * b[7..4]) * 2^8) +
  ((a[7..4] * b[3..0]) * 2^4) +
  ((a[3..0] * b[7..4]) * 2^4) +
  ((a[3..0] * b[3..0]) * 2^0)

## Block Diagram

The block diagram of the 8x8 bit sequential multiplier is shown below:


The design consists of an 8x8 bit multiplier with 8-bit inputs (DataA and DataB) and a 16-bit output (Product8x8_out). The sequential approach is used to perform the multiplication, ensuring accurate results. The output is provided on a 16-bit bus, enabling efficient data transfer.

## Multiplexed Bi-Directional Bus

The design incorporates a multiplexed bi-directional bus. This approach allows the same set of pins to be used for both input and output operations, reducing the overall number of pins required for the multiplier. By multiplexing the bus, the design achieves improved resource utilization and simplifies the interface.

##  Manual Binary Multiplication

![image](https://github.com/islamibr/8x8_seq_mult/assets/49861069/0296cb44-4010-452b-97f9-3c59fc1729bf)

## Shift-and-Add Multiplication

When designing multipliers, there is always a trade-off between the speed of the multiplication process and the hardware resources used for its implementation. One simple multiplication method that is slow but efficient in terms of hardware utilization is the shift-and-add method.

In the shift-and-add method, the multiplication is performed by considering each bit of one operand (let's call it A) and determining whether to add the other operand (B) to the accumulated partial result, followed by a right shift operation, or to perform only a right shift operation without the addition.

This method is justified by considering how binary multiplication is done manually. When manually multiplying two 8-bit binary numbers, we start by considering the bits of A from right to left. If a bit value is 0, we select 00000000 to be added with the next partial product. If the bit value is 1, we select the value of B. This process repeats, with each selection (00000000 or B) being written one place to the left with respect to the previous value. Once all bits of A are considered, we add all the calculated values to obtain the final multiplication result.

To facilitate the hardware implementation of this procedure, certain modifications are made. First, instead of moving the observation point from one bit of A to another, A is placed in a shift register, allowing the right-most bit to be observed. After each calculation, the shift register is shifted one place to the right, making the next bit accessible.

Second, for the partial products, instead of writing one partial product and the next one to its left, the partial product is moved to the right as it is written, eliminating the need for subsequent shifting.

Finally, instead of calculating all the partial products and adding them up at the end, each partial product is added to the previous partial result, and the newly calculated value becomes the new partial result.

In this modified procedure, if the observed bit of A is 0, 00000000 is added to the previously calculated partial result, and the new value is shifted one place to the right. Since the value being added is 00000000, the addition operation is not necessary, and only shifting the partial result is required. This operation is referred to as a "shift". However, if the observed bit of A is 1, B is added to the previously calculated partial result, and the resulting sum is shifted one place to the right. This is known as an "add-and-shift" operation.

By repeating the above procedure until all bits of A are shifted out, the partial result becomes the final multiplication result. To illustrate this procedure, let's consider a 4-bit example. Figure 11.3 shows the initial state, where A = 1001 and B = 1101 are the operands to be multiplied. At time 0, A is in a shift register with a register for partial results (P) on its left.

![image](https://github.com/islamibr/8x8_seq_mult/assets/49861069/5cf3ea8a-c4d0-45c3-b48c-b6bf53a121af)

