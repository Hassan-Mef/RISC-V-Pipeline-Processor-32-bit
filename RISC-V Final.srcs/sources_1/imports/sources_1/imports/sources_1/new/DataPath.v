`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 05:07:09 PM
// Design Name: 
// Module Name: DataPath
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


module DataPath(
    input clk,
    input rst,
    input Branch,
    input MemRead,
    input MemtoReg,
    input [1:0]ALUOp,
    input MemWrite,
    input ALUSrc,
    input RegWrite,
    output [31:0]Instruction
);
    wire zero;
    wire [31:0] address_in; // PC input
    wire [31:0] pc_address_in; // PC Adder out 
    wire [31:0] address_out ;  // PC input
    wire [31:0] reg_out_1, reg_out_2;  // Register File out
    wire [3:0] ALUControl_out; // ALU Control out
    wire [31:0] Alu_Result; // ALU out
    wire [31:0] immGen_out; // Immediate Generator out
    wire [31:0]  Data_Mem_out; // Data Memory out
    wire [31:0] DataMem_mux;  // Data Memory Mux out
    wire [31:0] Shifited_address; // Shifted address
    wire [31:0] branch_address; // Address for branch
    wire [31:0] Mux_out ;  // Mux out
    wire [31:0] ALU_Mux_out ;  // Mux out

    wire branch_sel;


    // wires for units in pipeline
    // wires for IF ID stage
    wire [31:0] pipe_pc_out_if;
    wire [31:0] pipe_inst_out_if;
    // wires for ID EX stage
    wire [31:0] pipe_pc_out_ex;
    wire [31:0] pipe_reg_out_1;
    wire [31:0] pipe_reg_out_2;
    wire [31:0] pipe_immGen_out;
    wire [4:0] pipe_rd_out_ex;
    wire [2:0] pipe_func3_out_ex;
    wire [6:0] pipe_func7_out_ex;
    wire [4:0] pipe_rs1_out_ex;
    wire [4:0] pipe_rs2_out_ex;
    wire branch_out_ex;
    // wires for EX MEM stage
    wire [31:0] pipe_alu_result_mem;
    wire [31:0] pipe_data_reg2_mem;
    wire [31:0] pipe_pc_out_mem;
    wire [4:0] pipe_rd_out_mem;
    wire [2:0] pipe_func3_out_mem;
    wire zero_out_mem;
    wire branch_out_mem;
    
    wire [31:0] branch_address_ex;  // EX-stage branch target
    wire [31:0] branch_address_mem; // MEM-stage branch target

    // wires for MEM WB stage
    wire [31:0] Data_Mem_out_wb;
    wire [31:0] pipe_alu_result_mem_wb;
    wire [4:0] pipe_rd_out_mem_wb;




    // wires for control signals in pipeline
    // wires for ID EX stage
    wire pipe_RegWrite_out;
    wire pipe_MemtoReg_out;
    wire pipe_MemRead_out;
    wire pipe_MemWrite_out;
    wire pipe_ALUSrc_out;
    wire [1:0] pipe_ALUOp_out;
    wire pipe_Branch_out;

    // wires for EX MEM stage
    wire pipe_MemRead_out_ex;
    wire pipe_MemWrite_out_ex;
    wire pipe_RegWrite_out_ex;
    wire pipe_MemtoReg_out_ex;

    // wires for MEM WB stage
    wire pipe_RegWrite_out_mem;
    wire pipe_MemtoReg_out_mem;

    // --- wires for forwarding ---
    wire [1:0] ForwardA, ForwardB;
    wire [31:0] ALU_src1, ALU_src2_pre;  // after forwarding but before ALUSrc MUX
    

    Mux Pc_mux(.in1(pc_address_in_finalcre), .in2(branch_address_mem), .sel(branch_sel), .out(address_in_final) );

    PC pc(.clk(clk), .rst(rst), .address(address_in_final), .PC_out(address_out));    
 
    Adder_pc PC_adder(.In(address_out), .Out(pc_address_in_finalcre));

    // wire branch_sel;
    // and branch_selector(branch_sel, Branch , zero) ;

    
    Instruction_Memory Inst_mem(.address(address_out), .Instruction(Instruction));

    IF_ID_Register stage1(.clk(clk), .rst(rst), 
    .pc_in(address_out) , .inst_in(Instruction), 
    .pc_out(pipe_pc_out_if), .inst_out(pipe_inst_out_if)
    );

    // After IF ID Stage

    Reg_File reg_file(.clk(clk), .rst(rst), .rs1(pipe_inst_out_if[19:15]), .rs2(pipe_inst_out_if[24:20]), .rd(pipe_rd_out_mem_wb), .write_data(DataMem_mux), .reg_write(pipe_RegWrite_out_mem), .read_out1(reg_out_1), .read_out2(reg_out_2));

    Immediate_Gen imm_gen (.inst_in(pipe_inst_out_if), .imm_out(immGen_out));

    ID_EX_Register stage2(
        .clk(clk),
        .rst(rst),
        // Inputs from  control signals
        .alu_op_in(ALUOp),
        .alu_src_in(ALUSrc),
        .mem_read_in(MemRead),
        .mem_write_in(MemWrite),
        .reg_write_in(RegWrite),
        .mem_to_reg_in(MemtoReg),
        // Inputs from ID stage
        .pc_in(pipe_pc_out_if),
        // 
        .reg_data1_in(reg_out_1),
        .reg_data2_in(reg_out_2),
        .imm_in(immGen_out),
        .rd_in(pipe_inst_out_if[11:7]),
        .func3_in(pipe_inst_out_if[14:12]),
        .func7_in(pipe_inst_out_if[31:25]),
        .rs1_in(pipe_inst_out_if[19:15]),
        .rs2_in(pipe_inst_out_if[24:20]),
        .branch_in(Branch),

        // Ouputs to EX stage
        .pc_out(pipe_pc_out_ex),
        .reg_data1_out(pipe_reg_out_1),
        .reg_data2_out(pipe_reg_out_2),
        .imm_out(pipe_immGen_out),
        .rd_out(pipe_rd_out_ex),
        .func3_out(pipe_func3_out_ex),
        .func7_out(pipe_func7_out_ex),
        .rs1_out(pipe_rs1_out_ex),
        .rs2_out(pipe_rs2_out_ex),
        .branch_out(pipe_Branch_out),

        // Control signals output
        .alu_op_out(pipe_ALUOp_out),
        .alu_src_out(pipe_ALUSrc_out),
        .mem_read_out(pipe_MemRead_out),
        .mem_write_out(pipe_MemWrite_out),
        .reg_write_out(pipe_RegWrite_out),
        .mem_to_reg_out(pipe_MemtoReg_out)
    );

    // After ID EX Stage

    ForwardingUnit forward_unit (
        .ID_EX_rs1       (pipe_rs1_out_ex),
        .ID_EX_rs2       (pipe_rs2_out_ex),
        .EX_MEM_RegWrite (pipe_RegWrite_out_ex),
        .EX_MEM_rd       (pipe_rd_out_mem),
        .MEM_WB_RegWrite (pipe_RegWrite_out_mem),
        .MEM_WB_rd       (pipe_rd_out_mem_wb),
        .ForwardA        (ForwardA),
        .ForwardB        (ForwardB)
    );

   //  Mux the A operand
    Mux3to1 mux_forward_A (
        .in0 (pipe_reg_out_1),        // no forwarding
        .in1 (pipe_alu_result_mem),   // EX/MEM stage
        .in2 (DataMem_mux),           // MEM/WB stage (writeback data)
        .sel (ForwardA),
        .out (ALU_src1)
    );

   //  Mux the B operand before the ALUSrc MUX
    Mux3to1 mux_forward_B (
        .in0 (pipe_reg_out_2),
        .in1 (pipe_alu_result_mem),
        .in2 (DataMem_mux),
        .sel (ForwardB),
        .out (ALU_src2_pre)
    );

    // 
    Mux Alu_mux(
        .in1(ALU_src2_pre),
        .in2(pipe_immGen_out),
        .sel(pipe_ALUSrc_out),
        .out(ALU_Mux_out)
    );

    //  ALU Control stays the same
    ALU_Control_unit alu_control(
        .ALUOp      (pipe_ALUOp_out),
        .fun7       (pipe_func7_out_ex),
        .fun3       (pipe_func3_out_ex),
        .ALU_control(ALUControl_out)
    );

    // Finally the ALU itself uses the forwarded A and the ALUSrc result
    ALU alu(
        .in1        (ALU_src1),
        .in2        (ALU_Mux_out),
        .ALU_control(ALUControl_out),
        .ALU_result (Alu_Result),
        .zero       (zero)
    );

    leftShifter shifter (.data_in(pipe_immGen_out), .data_out(Shifited_address));

    Adder branch_Adder(.In1(pipe_pc_out_ex), .In2(Shifited_address), .Out(branch_address_ex));

    EX_MEM_Register stage3(
        .clk(clk),
        .rst(rst),
        // Inputs from EX stage
        .alu_result_in(Alu_Result),
        .reg_data2_in(pipe_reg_out_2),
        .pc_address_in(pipe_pc_out_ex),
        .rd_in(pipe_rd_out_ex),
        .func3_in(pipe_func3_out_ex),
        .zero_in(zero),
        .branch_address_in(branch_address_ex),
        
        
        // Outputs to MEM stage
        .alu_result_out(pipe_alu_result_mem),
        .reg_data2_out(pipe_data_reg2_mem),
        .pc_address_out(pipe_pc_out_mem),
        .rd_out(pipe_rd_out_mem),
        .func3_out(pipe_func3_out_mem),
        .branch_address_out(branch_address_mem),
        // Zero flag output
        .zero_out(zero_out_mem),

        // Control signals input
        .mem_read_in(pipe_MemRead_out),
        .mem_write_in(pipe_MemWrite_out),
        .reg_write_in(pipe_RegWrite_out),
        .mem_to_reg_in(pipe_MemtoReg_out),
        .branch_in(pipe_Branch_out),

        // Control signals output
        .mem_read_out(pipe_MemRead_out_ex),
        .mem_write_out(pipe_MemWrite_out_ex),
        .reg_write_out(pipe_RegWrite_out_ex),
        .mem_to_reg_out(pipe_MemtoReg_out_ex),
        .branch_out(branch_out_mem)
    );



    // After EX MEM Stage

    
    and branch_selector(branch_sel, branch_out_mem , zero_out_mem) ;

    Data_Memory memory(.Clk(clk), .rst(rst), .memWrite(pipe_MemWrite_out_ex), .memRead(pipe_MemRead_out_ex) , .func3(pipe_func3_out_mem), .address(pipe_alu_result_mem), .data_in(pipe_data_reg2_mem), .data_out(Data_Mem_out));

    MEM_WB_Register stage4(
        .clk(clk),
        .rst(rst),
        // Inputs from MEM stage
        .alu_result_in(pipe_alu_result_mem),
        .mem_data_in(Data_Mem_out),
        .rd_in(pipe_rd_out_mem),
        .mem_to_reg_in(pipe_MemtoReg_out_ex),
        .reg_write_in(pipe_RegWrite_out_ex),

        // Outputs to WB stage
        .alu_result_out(pipe_alu_result_mem_wb),
        .mem_data_out(Data_Mem_out_wb),
        .rd_out(pipe_rd_out_mem_wb),
        .mem_to_reg_out(pipe_MemtoReg_out_mem),
        .reg_write_out(pipe_RegWrite_out_mem)
    );

    





    // After MEM WB Stage

    Mux MemMux(.in1(pipe_alu_result_mem_wb), .in2(Data_Mem_out_wb), .sel(pipe_MemtoReg_out_mem), .out(DataMem_mux));
    


endmodule
