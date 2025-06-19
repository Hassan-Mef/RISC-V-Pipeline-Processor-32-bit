`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2025 03:36:56 PM
// Design Name: 
// Module Name: Pipe_Registers
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


module Pipe_Registers(

    );
endmodule


module IF_ID_Register (
    input clk,
    input rst,
    input [31:0] pc_in,
    input [31:0] inst_in,
    output reg [31:0] pc_out,
    output reg [31:0] inst_out
);
    // Internal latches for asynchronous write
    reg [31:0] pc_reg;
    reg [31:0] inst_reg;

    // Asynchronous write (inputs latch immediately)
    always @(*) begin
        pc_reg = pc_in;
        inst_reg = inst_in;
    end

    // Synchronous read (outputs updated on clock edge)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pc_out <= 0;
            inst_out <= 0;
        end else begin
            pc_out <= pc_reg;
            inst_out <= inst_reg;
        end
    end
endmodule


module ID_EX_Register (
    input clk,
    input rst,

    // Inputs from ID stage
    input [31:0] pc_in,
    input [31:0] reg_data1_in,
    input [31:0] reg_data2_in,
    input [31:0] imm_in,
    input [2:0] func3_in,
    input [6:0] func7_in,
    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,
    input branch_in,

    // Control signals input
    input [1:0] alu_op_in,
    input alu_src_in,
    input mem_read_in,
    input mem_write_in,
    input reg_write_in,
    input mem_to_reg_in,

    // Outputs to EX stage
    output reg [31:0] pc_out,
    output reg [31:0] reg_data1_out,
    output reg [31:0] reg_data2_out,
    output reg [31:0] imm_out,
    output reg [4:0] rd_out,
    output reg [2:0] func3_out,
    output reg [6:0] func7_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg branch_out,

    // Control signals output
    output reg [1:0] alu_op_out,
    output reg alu_src_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg reg_write_out,
    output reg mem_to_reg_out
);
    // Internal latches for asynchronous write
    reg [31:0] pc_reg, reg_data1_reg, reg_data2_reg, imm_reg;
    reg [4:0] rd_reg;
    reg [2:0] func3_reg;
    reg [6:0] func7_reg;
    reg [4:0] rs1_reg, rs2_reg;
    reg branch_reg;
    reg [1:0] alu_op_reg;
    reg alu_src_reg, mem_read_reg, mem_write_reg, reg_write_reg, mem_to_reg_reg;

    // Asynchronous write (inputs latch immediately)
    always @(*) begin
        pc_reg = pc_in;
        reg_data1_reg = reg_data1_in;
        reg_data2_reg = reg_data2_in;
        imm_reg = imm_in;
        rd_reg = rd_in;
        func3_reg = func3_in;
        func7_reg = func7_in;
        branch_reg = branch_in;
        alu_op_reg = alu_op_in;
        alu_src_reg = alu_src_in;
        mem_read_reg = mem_read_in;
        mem_write_reg = mem_write_in;
        reg_write_reg = reg_write_in;
        mem_to_reg_reg = mem_to_reg_in;
        rs1_reg = rs1_in;
        rs2_reg = rs2_in;
    end

    // Synchronous read (outputs updated on clock edge)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reset outputs
            pc_out <= 0;
            reg_data1_out <= 0;
            reg_data2_out <= 0;
            imm_out <= 0;
            rd_out <= 0;
            alu_op_out <= 0;
            alu_src_out <= 0;
            mem_read_out <= 0;
            mem_write_out <= 0;
            reg_write_out <= 0;
            mem_to_reg_out <= 0;
            func3_out <= 0;
            func7_out <= 0;
            branch_out <= 0;
            rs1_out <= 0;
            rs2_out <= 0;
        end else begin
            // Pass values to next stage
            pc_out <= pc_reg;
            reg_data1_out <= reg_data1_reg;
            reg_data2_out <= reg_data2_reg;
            imm_out <= imm_reg;
            rd_out <= rd_reg;
            alu_op_out <= alu_op_reg;
            alu_src_out <= alu_src_reg;
            mem_read_out <= mem_read_reg;
            mem_write_out <= mem_write_reg;
            reg_write_out <= reg_write_reg;
            mem_to_reg_out <= mem_to_reg_reg;
            func3_out <= func3_reg;
            func7_out <= func7_reg;
            branch_out <= branch_reg;
            rs1_out <= rs1_reg;
            rs2_out <= rs2_reg;
        end
    end
endmodule


module EX_MEM_Register (
    input clk,
    input rst,

    // Inputs from EX stage
    input [31:0] pc_address_in,
    input [31:0] alu_result_in,
    input [31:0] reg_data2_in,
    input [2:0] func3_in,
    input [4:0] rd_in,
    input zero_in,
    input [31:0] branch_address_in,

    // Control signals input
    input mem_read_in,
    input mem_write_in,
    input reg_write_in,
    input mem_to_reg_in,
    input branch_in,

    // Outputs to MEM stage
    output reg [31:0] pc_address_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] reg_data2_out,
    output reg [2:0] func3_out,
    output reg [4:0] rd_out,
    output reg zero_out,
    output reg [31:0] branch_address_out,

    // Control signals output
    output reg mem_read_out,
    output reg mem_write_out,
    output reg reg_write_out,
    output reg mem_to_reg_out,
    output reg branch_out
);
    // Internal latches for asynchronous write
    reg [31:0] pc_address_reg, alu_result_reg, reg_data2_reg, branch_address_reg;
    reg [2:0] func3_reg;
    reg [4:0] rd_reg;
    reg zero_reg;
    reg mem_read_reg, mem_write_reg, reg_write_reg, mem_to_reg_reg, branch_reg;

    // Asynchronous write (inputs latch immediately) 
    always @(*) begin
        pc_address_reg = pc_address_in;
        alu_result_reg = alu_result_in;
        reg_data2_reg = reg_data2_in;
        func3_reg = func3_in;
        rd_reg = rd_in;
        zero_reg = zero_in;
        branch_address_reg = branch_address_in;
        mem_read_reg = mem_read_in;
        mem_write_reg = mem_write_in;
        reg_write_reg = reg_write_in;
        mem_to_reg_reg = mem_to_reg_in;
        branch_reg = branch_in;
    end

    // Synchronous read (outputs updated on clock edge)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reset outputs
            alu_result_out <= 0;
            reg_data2_out <= 0;
            rd_out <= 0;
            zero_out <= 0;
            mem_read_out <= 0;
            mem_write_out <= 0;
            reg_write_out <= 0;
            mem_to_reg_out <= 0;
            pc_address_out <= 0;
            func3_out <= 0;
            branch_address_out <= 0;
            branch_out <= 0;
        end else begin
            // Pass values to next stage
            alu_result_out <= alu_result_reg;
            reg_data2_out <= reg_data2_reg;
            rd_out <= rd_reg;
            zero_out <= zero_reg;
            mem_read_out <= mem_read_reg;
            mem_write_out <= mem_write_reg;
            reg_write_out <= reg_write_reg;
            mem_to_reg_out <= mem_to_reg_reg;
            pc_address_out <= pc_address_reg;
            func3_out <= func3_reg;
            branch_address_out <= branch_address_reg;
            branch_out <= branch_reg;
        end
    end
endmodule


module MEM_WB_Register (
    input clk,
    input rst,

    // Inputs from MEM stage
    input [31:0] mem_data_in,
    input [31:0] alu_result_in,
    input [4:0] rd_in,

    // Control signals input
    input reg_write_in,
    input mem_to_reg_in,

    // Outputs to WB stage
    output reg [31:0] mem_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] rd_out,
    output reg reg_write_out,
    output reg mem_to_reg_out
);
    // Internal latches for asynchronous write
    reg [31:0] mem_data_reg, alu_result_reg;
    reg [4:0] rd_reg;
    reg reg_write_reg, mem_to_reg_reg;

    // Asynchronous write (inputs latch immediately)
    always @(*) begin
        mem_data_reg = mem_data_in;
        alu_result_reg = alu_result_in;
        rd_reg = rd_in;
        reg_write_reg = reg_write_in;
        mem_to_reg_reg = mem_to_reg_in;
    end

    // Synchronous read (outputs updated on clock edge)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reset outputs
            mem_data_out <= 0;
            alu_result_out <= 0;
            rd_out <= 0;
            reg_write_out <= 0;
            mem_to_reg_out <= 0;
        end else begin
            // Pass values to next stage
            mem_data_out <= mem_data_reg;
            alu_result_out <= alu_result_reg;
            rd_out <= rd_reg;
            reg_write_out <= reg_write_reg;
            mem_to_reg_out <= mem_to_reg_reg;
        end
    end
endmodule
