`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2025 04:57:45 PM
// Design Name: 
// Module Name: Processor_tb
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


module Processor_tb();

    reg clk;
    reg rst;

    Processor testing(
        .clk(clk),
        .rst(rst)
    );

     // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Reset pulse and simulation control
    initial begin
        clk   = 0;
        rst = 0;        // Assert rst (active-low)
        #10;
        rst = 1;        // De-assert rst after 20 ns
        #150;
    end

   


endmodule
