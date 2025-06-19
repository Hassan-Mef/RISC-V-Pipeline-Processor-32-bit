`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 07:03:03 PM
// Design Name: 
// Module Name: ALU_Control_unit
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


module ALU_Control_unit(
    input [1:0]ALUOp,
    input [6:0] fun7,
    input [2:0] fun3,
    output reg [3:0]ALU_control
    );

    always @(*) begin

        case(ALUOp)
        // load store case
        2'b00: ALU_control = 4'b0000;
        2'b01: ALU_control = 4'b0110;
        2'b10: begin 
            case({fun7 , fun3})
                //add
                {7'b0000000, 3'b000}: ALU_control = 4'b0000;
                // sub
                {7'b0100000, 3'b000}: ALU_control = 4'b0011;
                // SLL
                {7'b0000000, 3'b001}: ALU_control = 4'b0001;
                // SLT
                {7'b0000000, 3'b010}: ALU_control = 4'b0010;
                // XOR
                {7'b0000000, 3'b100}: ALU_control = 4'b0100;
                // SRL
                {7'b0000000, 3'b101}: ALU_control = 4'b0101;
                // OR
                {7'b0000000, 3'b110}: ALU_control = 4'b0110;
                // AND
                {7'b0000000, 3'b111}: ALU_control = 4'b0111;
                default: ALU_control = 4'b0000;  
            endcase
        end

        default: ALU_control = 4'b0000;  
    endcase
end


endmodule
