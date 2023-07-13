# 8x8 Bit Sequential Multiplier

The 8x8 Bit Sequential Multiplier is a Verilog design that implements an 8x8 bit multiplier using a sequential approach. This project aims to provide an efficient and modular solution for performing multiplication operations on 8-bit operands, resulting in a 16-bit product. The design supports various features, including multi-cycle computation, output signaling, and efficient pin utilization.

## Sequential Multiplier Specification


The project's goal is to build an 8x8 multiplier that takes two 8-bit multiplicands (`dataa` and `datab`) as inputs and produces a 16-bit product (`product8x8_out`). Additionally, the design provides a done flag (`done_flag`) and seven signals (`seg_a`, `seg_b`, `seg_c`, `seg_d`, `seg_e`, `seg_f`, and `seg_g`) to drive a 7-segment display. The multiplier operates in a multi-cycle fashion, requiring four clock cycles to complete the full multiplication.

### Functionality

The multiplier utilizes a sequential approach to perform the multiplication operation. During each of the four clock cycles, a pair of 4-bit slices from `dataa` and `datab` is multiplied by a 4x4 multiplier. The resulting 4-bit slices are then accumulated to obtain the final 16-bit product. On the fifth cycle, the fully composed 16-bit product is available at the output (`product8x8_out`).


## Mathematical Principle

The multiplier's functionality is based on the mathematical principles of multiplication. It breaks down the 8-bit multiplicands `a` and `b` into 4-bit slices and performs partial multiplications. The final 16-bit product is obtained by summing the individual partial products according to the following equation:


![CodeCogsEqn](https://github.com/islamibr/8x8_seq_mult/assets/49861069/d10aeb9d-f56b-451c-9eea-27d25b1fb2de)

### Shift-and-Add Multiplication

When designing multipliers, there is always a trade-off between the speed of the multiplication process and the hardware resources used for its implementation. One simple multiplication method that is slow but efficient in terms of hardware utilization is the shift-and-add method.

In the shift-and-add method, the multiplication is performed by considering each bit of one operand (let's call it A) and determining whether to add the other operand (B) to the accumulated partial result, followed by a right shift operation, or to perform only a right shift operation without the addition.

This method is justified by considering how binary multiplication is done manually. When manually multiplying two 8-bit binary numbers, we start by considering the bits of A from right to left. If a bit value is 0, we select 00000000 to be added with the next partial product. If the bit value is 1, we select the value of B. This process repeats, with each selection (00000000 or B) being written one place to the left with respect to the previous value. Once all bits of A are considered, we add all the calculated values to obtain the final multiplication result.

To facilitate the hardware implementation of this procedure, certain modifications are made. First, instead of moving the observation point from one bit of A to another, A is placed in a shift register, allowing the right-most bit to be observed. After each calculation, the shift register is shifted one place to the right, making the next bit accessible.

Second, for the partial products, instead of writing one partial product and the next one to its left, the partial product is moved to the right as it is written, eliminating the need for subsequent shifting.

Finally, instead of calculating all the partial products and adding them up at the end, each partial product is added to the previous partial result, and the newly calculated value becomes the new partial result.

In this modified procedure, if the observed bit of A is 0, 00000000 is added to the previously calculated partial result, and the new value is shifted one place to the right. Since the value being added is 00000000, the addition operation is not necessary, and only shifting the partial result is required. This operation is referred to as a "shift". However, if the observed bit of A is 1, B is added to the previously calculated partial result, and the resulting sum is shifted one place to the right. This is known as an "add-and-shift" operation.

By repeating the above procedure until all bits of A are shifted out, the partial result becomes the final multiplication result. To illustrate this procedure, let's consider a 4-bit example. Figure 11.3 shows the initial state, where A = 1001 and B = 1101 are the operands to be multiplied. At time 0, A is in a shift register with a register for partial results (P) on its left.

<p align="center">
  <img src="https://github.com/islamibr/8x8_seq_mult/assets/49861069/5cf3ea8a-c4d0-45c3-b48c-b6bf53a121af" alt="Manual binary multiplication">
  <br>
  <em>Manual binary multiplication</em>
</p>

<p align="center">
  <img src="https://github.com/islamibr/8x8_seq_mult/assets/49861069/0296cb44-4010-452b-97f9-3c59fc1729bf" alt="Hardware binary multiplication">
  <br>
  <em>Hardware binary multiplication</em>
</p>


## Block Diagram

The block diagram of the 8x8 bit sequential multiplier is shown below:
![image](https://github.com/islamibr/8x8_seq_mult/assets/49861069/053b19f3-4d3a-4370-8e96-2c1fc8f947b6)


The design consists of an 8x8 bit multiplier with 8-bit inputs (DataA and DataB) and a 16-bit output (Product8x8_out). The sequential approach is used to perform the multiplication, ensuring accurate results. The output is provided on a 16-bit bus, enabling efficient data transfer.

## Hardware-Oriented Multiplication Process

The 8x8 bit sequential multiplier design implements a hardware-oriented multiplication process. Let's explore the steps involved in this process:

1. At time 0, because A[0] is 1, the partial sum of B + P is calculated. This partial sum, represented as 01101 (shown in the upper part of time 1), consists of 5 bits, including a carry. The rightmost bit of this partial sum is shifted into the A register, replacing the old value of A. The remaining bits of the partial sum replace the old value of P. During this shifting operation, a 0 is moved into the A[0] position.

2. At time 1, the new value in A is observed. Since A[0] is 0, the calculation changes to 0000 + P instead of B + P. This results in a new value of 00110. The rightmost bit of this value is shifted into A, while the other bits replace the old value of P.

3. This process repeats for a total of 4 cycles. During each cycle, the multiplication process proceeds as described above. At the end of the fourth cycle, both the A and P registers hold the final multiplication result. The least significant 4 bits of the result are stored in A, while the most significant bits are stored in P.

For example, consider the operation of multiplying 9 and 13. By following the hardware-oriented multiplication process, the result obtained is 117.

This hardware-oriented approach efficiently performs multiplication in the 8x8 bit sequential multiplier, gradually accumulating the result in the A and P registers over multiple cycles.

![image](https://github.com/islamibr/8x8_seq_mult/assets/49861069/e08da817-3a64-43b8-942d-5c0aad0cc9b0)
![image](https://github.com/islamibr/8x8_seq_mult/assets/49861069/820e43f6-c47f-4fd3-88b9-fefbf86687d2)




