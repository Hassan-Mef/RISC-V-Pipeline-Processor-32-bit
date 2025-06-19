`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 06:54:14 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] ALU_control,
    output reg [31:0] ALU_result,
    output reg zero

    );

    always@(*) begin
        case(ALU_control)
            4'b0000: ALU_result = in1 +in2 ;
            4'b0001: ALU_result = in1 << in2 ;
            4'b0010: ALU_result =  ((in1 < in2) ? 32'b1 : 32'b0);
            4'b0011: ALU_result = in1  - in2 ;
            4'b0100: ALU_result = in1 ^ in2;
            4'b0101: ALU_result = in1 >> in2 ;
            4'b0110: ALU_result = in1 | in2;
            4'b0111: ALU_result = in1 & in2;

            // Set the zero flag
            4'b1000: zero = ((in1 == in2) ? 1'b1 : 1'b0);
            4'b1001 : zero = ((in1 != in2) ? 1'b1 : 1'b0);
            4'b1010 : zero = ((in1 < in2) ? 1'b1 : 1'b0);
            4'b1011 : zero = ((in1 >= in2) ? 1'b1 : 1'b0);
            4'b1100 : zero = ((in1 < in2) ? 1'b1 : 1'b0);
            4'b1101 : zero = ((in1 >= in2) ? 1'b1 : 1'b0);
        
            default: begin 
                ALU_result = 32'b0;
                zero = 1'b0; // Default case for zero flag
            end
        endcase

    end

endmodule

