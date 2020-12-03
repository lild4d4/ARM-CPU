`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2020 13:26:10
// Design Name: 
// Module Name: CPU
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


module CPU(
    input logic clk,reset,
    output logic MemWrite,
    output logic [31:0] ALUResult,WriteDataM,
    input logic [31:0] ReadData
    );
    //controller---------------------------------------------------------------------------
    logic [3:0] ALUFlags;
    logic RegWriteD,RegWriteE,RegWriteM,RegWriteW,ALUSrcD,ALUSrcE,MemtoRegD,MemtoRegE,MemtoRegM,MemtoRegW,PCSrcD,PCSrcE,PCSrcM,PCSrcW;
    logic [1:0] RegSrc,ImmSrc,ALUControlD,ALUControlE;
    
    logic [1:0] FlagW;
    logic PCS, RegW, MemW;
    
    decoder dec(InstrD[27:26],InstrD[25:20],InstrD[15:12],FlagW,
         PCSrcD,RegW,MemW,MemtoRegD,ALUSrcD,ImmSrc,RegSrc,ALUControlD);
    
    
    
    condlogic cl(clk,reset,InstrD[31:28],ALUFlags,FlagW,PCSrcE,RegW,
                MemW,PCS,RegWriteE,MemWrite);
    
    //controller c(clk,reset,InstrD[31:12],ALUFlags,RegSrc,RegWrite,ImmSrc,ALUSrc,ALUControl,
    //                MemWrite,MemtoReg,PCSrc);
                    
    //DataPath-----------------------------------------------------------------------------
    logic [31:0] PCNext,PCPlus4,WA3M;
    logic [31:0] ExtImm,ExtImmE,SrcA,SrcB,SrcAE,Result,WA3W,WA3E,WriteDataE;
    logic [3:0] RA1,RA2;
    logic [31:0] PC,InstrF,InstrD,ALUOutM,ALUOutW,ReadDataW;
    
    //Fetch
    mux2 #(32) pcmux(PCPlus4,Result,PCSrc,PCNext);
    flopr #(32) pcreg(clk,reset,PCNext,PC);
    adder #(32) pcadd1(PC,32'b100,PCPlus4);
    imem imem(PC,InstrF);
    
    flopr #(32) ffFetch1(clk,reset,InstrF,InstrD);
    
    //Decode
    mux2 #(4) ra1mux(InstrD[19:16],4'b1111,RegSrc[0],RA1);
    mux2 #(4) ra2mux(InstrD[3:0],InstrD[15:12],RegSrc[1],RA2);
    regfile rf(clk,RegWriteW,RA1,RA2,WA3W,Result,PCPlus4,SrcA,WriteData);
    extend ext(InstrD[23:0],ImmSrc,ExtImm);
    
    flopr #(32) ffDecode1(clk,reset,SrcA,SrcAE);
    flopr #(32) ffDecode2(clk,reset,WriteData,WriteDataE);
    flopr #(32) ffDecode3(clk,reset,InstrD[15:12],WA3E);
    flopr #(32) ffDecode4(clk,reset,ExtImm,ExtImmE);
    
    //Execute
    mux2 #(32) srcbmux(WriteDataE,ExtImmE,ALUSrcE,SrcB);
    ALU_ref #(32) alu(SrcAE,SrcB,ALUControlE,ALUResult,ALUFlags);
    
    flopr #(32) ffexe1(clk,reset,ALUResult,ALUOutM);
    flopr #(32) ffexe2(clk,reset,WriteDataE,WriteDataM);
    flopr #(32) ffexe3(clk,reset,WA3E,WA3M);
    
    //Memory
    dmem dmem(clk,MemWrite,ALUOutM,WriteDataM,ReadData);
    
    flopr #(32) ffmem1(clk,reset,ReadData,ReadDataW);
    flopr #(32) ffmem2(clk,reset,ALUOutM,ALUOutW);
    flopr #(32) ffmem3(clk,reset,WA3M,WA3W);
    
    //Write Back
    mux2 #(32) resmux(ALUOutW,ReadDataW,MemtoRegW,Result);
    
        
endmodule
