`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 06:04:07 PM
// Design Name: 
// Module Name: Control_unit
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


module Control_unit(
    input [6:0] opcode,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg PC_Src,
    output  reg [1:0] ALUOp
    );


    always@(*) begin 
        case(opcode)
        7'b0110011:begin  // R type
            ALUSrc = 0;
            MemtoReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            PC_Src = 0;
            ALUOp = 2'b10;
        end
        7'b0010011:begin //I type
            ALUSrc = 1;
            MemtoReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            PC_Src = 0;
            ALUOp = 2'b10;
        end
        7'b0000011:begin   // Load type
            ALUSrc = 1;
            MemtoReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            Branch = 0;
            PC_Src = 0;
            ALUOp = 2'b00;
        end
        7'b0100011:begin   // Store type
            ALUSrc = 1;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            Branch = 0;
            PC_Src = 0;
            ALUOp = 2'b00;
        end
        7'b1101111:begin   // J type 
            ALUSrc = 0;
            MemtoReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 1;
            PC_Src = 1;    // branch here is x
            ALUOp = 2'b00;
        end
        7'b1100011:begin   // B type
            ALUSrc = 0;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 1;
            PC_Src = 0;    // branch here is x
            ALUOp = 2'b01;
        end
        endcase
    end


endmodule
