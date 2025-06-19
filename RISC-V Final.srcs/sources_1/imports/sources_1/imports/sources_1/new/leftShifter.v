`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2025 02:17:46 PM
// Design Name: 
// Module Name: leftShifter
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


module leftShifter(
 input [31:0]data_in,
    output [31:0]data_out
    );
    assign data_out = data_in << 1 ;
endmodule
