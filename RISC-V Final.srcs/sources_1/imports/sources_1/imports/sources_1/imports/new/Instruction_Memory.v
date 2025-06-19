`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 07:38:24 PM
// Design Name: 
// Module Name: Instruction_Memory
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


module Instruction_Memory(

    input [31:0]address,
    output reg [31:0]Instruction
    );

    reg [8192-1:0]Inst_memory ;

    initial begin 
        
        // Inst_memory[31:0]     = 32'h00000293;  // addi x5, x0, 0
        // Inst_memory[63:32]    = 32'h00100313;  // addi x6, x0, 1
        // Inst_memory[95:64]    = 32'h005303B3;  // add x7, x6, x5
        // Inst_memory[127:96]  = 32'h40B30433;  // sub x8, x6, x5
        // Inst_memory[159:128] = 32'h20B30533;  // mul x9, x6, x5
        // Inst_memory[191:160] = 32'h00B316B3;  // sll x10, x6, x5  

    //     Inst_memory[31:0]     = 32'h00600293;  // addi x5, x0, 6     -> x5 = 6
    // Inst_memory[63:32]    = 32'h00700313;  // addi x6, x0, 7     -> x6 = 7
    // Inst_memory[95:64]    = 32'h005303B3;  // add  x7, x6, x5    -> x7 = 7 + 6 = 13

    // // sub x8, x7, x5 (13 - 6 = 7,)
    // Inst_memory[127:96]   = 32'b01000000010100111000010000110011;  // sub  x8, x7, x5

    // // mul x9, x6, x5 (7 * 6 = 42)
    // Inst_memory[159:128]  = 32'h02030533;  // mul  x9, x6, x5

    // // sll x10, x5, x0 (6 << 0 = 6, no shift so safe positive)
    // Inst_memory[191:160]  = 32'h0002A6B3;  // sll  x10, x5, x0
    
    // new 2

    // working instructions with hazards
//    //add x5, x4, x3   = 7
//     Inst_memory[31:0]     = 32'b00000000001100100000001010110011;
//     // add x6, x2, x1    = 3
//     Inst_memory[63:32]    = 32'b0000000_00001_00010_000_00110_0110011;
//     // sub x3, x2, x1      = 1
//     Inst_memory[95:64]    = 32'h401101b3;
//     // or x9, x6, x5
//     Inst_memory[127:96]   = 32'b00000000010100110110010010110011;
//     // sll x12, x2, x1
//     Inst_memory[159:128]  = 32'b00000000000100010001011000110011;

//     // sub x8, x7, x5 (13 - 6 = 7,)
//     Inst_memory[191:160]   = 32'b0100000_00101_00111_000_01000_0110011;  // sub  x8, x7, x5
//     // sw x5, 4(x1)
//     Inst_memory[223:192]  = 32'b00000000010100001010001000100011;
//     // lw x10, 0(x0)
//     Inst_memory[255:224]  = 32'b00000000000000000010101000000011;

//     //sw x14, 6(x0)
//     Inst_memory[287:256]  = 32'b0000000_01110_00000_010_00110_0100011;

//     // lw x15, 6(x0)
//     Inst_memory[319:288]  = 32'b000000000110_00000_010_01111_0000011;



/// testing--------------------------

// Original instructions (first 5)
Inst_memory[31:0]     = 32'b00000000001100100000001010110011;   // add x5, x4, x3
Inst_memory[63:32]    = 32'b0000000_00001_00101_000_00110_0110011;  // add x6, x5, x1
Inst_memory[95:64]    = 32'h401101b3;                           // sub x3, x2, x1
Inst_memory[127:96]   = 32'b00000000010100110110010010110011;   // or x9, x6, x5
Inst_memory[159:128]  = 32'b00000000000000010001011000110011;   // sll x12, x2, x0

// Store/Load test sequence (corrected indices)
Inst_memory[191:160]  = 32'h00000013;  // nop (addi x0, x0, 0)
Inst_memory[223:192]  = 32'h00000013;  // nop (addi x0, x0, 0)
Inst_memory[255:224]  = 32'h0050a223;  // sw x5, 4(x1)  [assuming x1=0]
Inst_memory[287:256]  = 32'h0060a423;  // NOP (not used in this sequence)
Inst_memory[319:288]  = 32'h00000713;  // addi x14, x0, 0 (x14=0)
Inst_memory[351:320]  = 32'h00170713;  // addi x14, x14, 1 (x14=1)
Inst_memory[383:352]  = 32'h00270713;  // addi x14, x14, 2 (x14=3)
Inst_memory[415:384]  = 32'h00000013;  // nop
Inst_memory[447:416]  = 32'h00000013;  // nop
Inst_memory[479:448]  = 32'h0040a503;  // lw x10, 4(x1) (load x5 value)
Inst_memory[511:480]  = 32'h0080a583;  // NOP (not used in this sequence)
Inst_memory[543:512]  = 32'h0010a423;  // sw x1, 8(x1)
Inst_memory[575:544]  = 32'h0080a583;  // lw x11, 8(x1) (load x6 value)







    // stalling 


//     Inst_memory[31:0]     = 32'b00000000001100100000001010110011;   // add x5, x4, x3
// Inst_memory[63:32]    = 32'b0000000_00001_00010_000_00110_0110011;  // add x6, x2, x1
// Inst_memory[95:64]    = 32'h401101b3;                           // sub x3, x2, x1
// Inst_memory[127:96]   = 32'b00000000010100110110010010110011;   // or x9, x6, x5
// Inst_memory[159:128]  = 32'b00000000000100010001011000110011;   // sll x12, x2, x1


// Inst_memory[191:160]  = 32'b0100000_00101_00111_000_01000_0110011;  // sub x8, x7, x5
// Inst_memory[223:192]  = 32'b00000000000000000000000000010011;   // DUMMY: addi x0, x0, 0
// // Inst_memory[255:224]  = 32'b00000000000000000000000000010011;   // DUMMY: addi x0, x0, 0

// // Remaining instructions
// Inst_memory[255:224]  = 32'b00000000010100001010001000100011;   // sw x5, 4(x1)
// Inst_memory[287:256]  = 32'b00000000000000000010101000000011;   // lw x10, 0(x0)
// Inst_memory[319:288]  = 32'b0000000_01110_00000_010_00110_0100011;  // sw x14, 6(x0)
// Inst_memory[351:320]  = 32'b000000000110_00000_010_01111_0000011;   // lw x15, 6(x0)
    end


    always@(*) begin
        Instruction = Inst_memory[address[9:2]*32 +: 32]; 
    end

    
endmodule
