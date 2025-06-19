`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 05:14:57 PM
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input rst,
    input [31:0] address,
    output [31:0] PC_out

    );

    reg [31:0] PC;
    always @(posedge clk or negedge rst) begin
        if(!rst)
            PC <= 32'b0;
        else
          PC <= address;
    end

    assign PC_out = PC;

    
endmodule
