`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2025 02:05:18 PM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
    input  [4:0] ID_EX_rs1,       // source reg #1 of current EX instruction
    input  [4:0] ID_EX_rs2,       // source reg #2 of current EX instruction
    input        EX_MEM_RegWrite, // is EX/MEM writing?
    input  [4:0] EX_MEM_rd,       // destination reg of EX/MEM
    input        MEM_WB_RegWrite, // is MEM/WB writing?
    input  [4:0] MEM_WB_rd,       // destination reg of MEM/WB
    output reg [1:0] ForwardA,    // 00=use reg, 10=EX/MEM, 01=MEM/WB
    output reg [1:0] ForwardB     // same for second operand
    );

    always @(*) begin
        // Default: no forwarding
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // EX hazard: EX/MEM.rd != 0 && matches ID/EX.rs1
        if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1))
            ForwardA = 2'b10;
        if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2))
            ForwardB = 2'b10;

        // MEM hazard: MEM/WB.rd != 0 && matches ID/EX.rsX
        if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && 
            !(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1)) &&
            (MEM_WB_rd == ID_EX_rs1))
            ForwardA = 2'b01;
        if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && 
            !(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2)) &&
            (MEM_WB_rd == ID_EX_rs2))
            ForwardB = 2'b01;
    end
endmodule


module Mux3to1(
    input  [31:0] in0, in1, in2,
    input  [1:0]  sel,
    output reg [31:0] out
);
    always @(*) case(sel)
        2'b00: out = in0;
        2'b10: out = in1;
        2'b01: out = in2;
        default: out = in0;
    endcase
endmodule



