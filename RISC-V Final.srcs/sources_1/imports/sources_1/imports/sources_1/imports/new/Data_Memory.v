`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2025 06:58:20 PM
// Design Name: 
// Module Name: Data_Memory
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


module Data_Memory(
    input Clk, rst,
    input memWrite,
    input memRead,
    input [2:0] func3,
    input [31:0] address,
    input [31:0] data_in,
    output reg [31:0] data_out 

    );

    reg [(1024*8)-1:0] data_memory;



    always @(*)begin
        if(memRead)begin
            case(func3)
            3'b000: data_out = {24'b0,data_memory[address*8+: 8]};
            3'b001 : data_out = {16'b0,data_memory[address*8+: 16]};
            3'b010 : data_out = data_memory[address*8+: 32];
            endcase
        end
    end

    integer i;

    always @(posedge Clk) begin 
        if(!rst) begin 
        for(i =0 ; i < 1024; i =i+1)
            data_memory[i] <= 0 ;
        end
    if(memWrite)begin
        case(func3)
        3'b000: data_memory[address*8+: 8] <=data_in;
        3'b001: data_memory[address*8+: 16] <=data_in;
        3'b010: data_memory[address*8+: 32] <=data_in;
        endcase
    end
    end

endmodule