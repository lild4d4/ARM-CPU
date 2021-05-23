`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2020 19:58:01
// Design Name: 
// Module Name: arm
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


module arm(
    input logic clk,reset,
    output logic [31:0] PC,
    input logic [31:0] Instr,
    output logic MemWrite,
    output logic [31:0] ALUResult,WriteData,
    input logic [31:0] ReadData
    );
    //controller---------------------------------------------------------------------------
    logic [3:0] ALUFlags;
    logic RegWrite,ALUSrc,MemtoReg,PCSrc;
    logic [1:0] RegSrc,ImmSrc,ALUControl;
    
    controller c(clk,reset,Instr[31:12],ALUFlags,RegSrc,RegWrite,ImmSrc,ALUSrc,ALUControl,
                    MemWrite,MemtoReg,PCSrc);
                    
    //DataPath-----------------------------------------------------------------------------
    logic [31:0] PCNext,PCPlus4,PCPlus8;
    logic [31:0] ExtImm,SrcA,SrcB,Result;
    logic [3:0] RA1,RA2;
    
    //next Pc logic
    mux2 #(32) pcmux(PCPlus4,Result,PCSrc,PCNext);
    flopr #(32) pcreg(clk,reset,PCNext,PC);
    adder #(32) pcadd1(PC,32'b100,PCPlus4);
    adder #(32) pcpadd2(PCPlus4,32'b100,PCPlus8);
    
    //register file logic
    mux2 #(4) ra1mux(Instr[19:16],4'b1111,RegSrc[0],RA1);
    mux2 #(4) ra2mux(Instr[3:0],Instr[15:12],RegSrc[1],RA2);
    regfile rf(clk,RegWrite,RA1,RA2,Instr[15:12],Result,PCPlus8,SrcA,WriteData);
    mux2 #(32) resmux(ALUResult,ReadData,MemtoReg,Result);
    extend ext(Instr[23:0],ImmSrc,ExtImm);
    
    //ALU logic
    mux2 #(32) srcbmux(WriteData,ExtImm,ALUSrc,SrcB);
    ALU_ref #(32) alu(SrcA,SrcB,ALUControl,ALUResult,ALUFlags);
        
endmodule
