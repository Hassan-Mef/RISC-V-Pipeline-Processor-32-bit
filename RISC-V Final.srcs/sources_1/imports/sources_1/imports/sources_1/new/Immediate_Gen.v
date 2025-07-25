`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 06:01:58 PM
// Design Name: 
// Module Name: Immediate_Gen
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


module Immediate_Gen(

    input [31:0] inst_in,
    output reg [31:0] imm_out
);

always @(*) begin
    case (inst_in[6:0])
        // I-type (load, ALU immediate)
        7'b0000011, 7'b0010011, 7'b1100111: 
            imm_out = {{20{inst_in[31]}}, inst_in[31:20]};
        
        // S-type (store)
        7'b0100011: 
            imm_out = {{20{inst_in[31]}}, inst_in[31:25], inst_in[11:7]};
        
        // B-type (branch)
        7'b1100011: 
            imm_out = {{19{inst_in[31]}}, inst_in[31], inst_in[7], inst_in[30:25], inst_in[11:8], 1'b0};

        // U-type (LUI, AUIPC)
        7'b0110111, 7'b0010111:
            imm_out = {inst_in[31:12], 12'b0};
        
        // J-type (JAL)
        7'b1101111:
            imm_out = {{11{inst_in[31]}}, inst_in[31], inst_in[19:12], inst_in[20], inst_in[30:21], 1'b0};

        // R-type (no immediate)
        7'b0110011:
            imm_out = 32'b0;

        default:
            imm_out = 32'b0;
    endcase
end

endmodule

