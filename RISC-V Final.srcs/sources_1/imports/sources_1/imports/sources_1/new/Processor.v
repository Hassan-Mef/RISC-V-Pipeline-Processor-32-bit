`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2025 04:25:55 PM
// Design Name: 
// Module Name: Processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Processor(
    input clk,
    input rst
    );

    wire [31:0] instruction; // Instruction Memory out
    wire ALUSrc, MemtoReg, MemRead, MemWrite, RegWrite, Branch , PC_src;
    wire [1:0] ALUOp;

    Control_unit Cu (
      .opcode(instruction[6:0]),
      .ALUSrc(ALUSrc),
      .MemtoReg(MemtoReg),
      .RegWrite(RegWrite),
      .MemRead(MemRead),
      .MemWrite(MemWrite),
      .Branch(Branch),
      .PC_Src(PC_src),
      .ALUOp(ALUOp)
    );

    DataPath Dp(
        .clk(clk),
        .rst(rst),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Instruction(instruction)   
    );


endmodule
