`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 05:19:36 PM
// Design Name: 
// Module Name: Reg_File
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


module Reg_File(
    input clk,
    input rst,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input reg_write,
    output [31:0] read_out1,
    output [31:0] read_out2

    );

    reg [31:0] registers [0:31];
   
    integer  i;
    


    always @(posedge clk or negedge rst) begin 
        if(!rst) begin
            for(i=0; i<32; i=i+1) begin
                registers[i] <= i;
            end
            
        end
        else if(reg_write) begin 
            registers[rd] <= write_data;
        end 
    end

    assign read_out1 = registers[rs1];
    assign read_out2 = registers[rs2];


endmodule
