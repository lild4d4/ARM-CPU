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
    output logic [31:0] WriteDataM,ALUOutM,
    output logic MemWriteM
    );
    //controller---------------------------------------------------------------------------
    logic [3:0] ALUFlags,CondE;
    logic RegWriteD,RegWriteE,RegWriteE2,RegWriteM,RegWriteW,ALUSrcD,ALUSrcE,MemtoRegD,MemtoRegE,MemtoRegM,MemtoRegW,PCSrcD,PCSrcE,PCSrcM,PCSrcW;
    logic [1:0] RegSrc,ImmSrc,ALUControlD,ALUControlE;
    logic StallF,StallD,FlushE;
    
    logic [1:0] FlagWriteD,FlagWriteE;
    logic PCS, MemWriteD,MemWriteE,MemWriteE2;
    //Control unit
    decoder dec(InstrD[27:26],InstrD[25:20],InstrD[15:12],FlagWriteD,
         PCSrcD,RegWriteD,MemWriteD,MemtoRegD,ALUSrcD,ImmSrc,RegSrc,ALUControlD);
    
    flopr #(1) ffCD1(clk,FlushE,PCSrcD,PCSrcE);
    flopr #(1) ffCD2(clk,FlushE,RegWriteD,RegWriteE);
    flopr #(1) ffCD3(clk,FlushE,MemtoRegD,MemtoRegE);
    flopr #(1) ffCD4(clk,FlushE,MemWriteD,MemWriteE);
    flopr #(2) ffCD5(clk,FlushE,ALUControlD,ALUControlE);
    flopr #(1) ffCD6(clk,FlushE,ALUSrcD,ALUSrcE);
    flopr #(2) ffCD7(clk,FlushE,FlagWriteD,FlagWriteE);
    flopr #(4) ffCD8(clk,FlushE,InstrD[31:28],CondE);
    
    //Conditional logic
    condlogic cl(clk,reset,CondE,ALUFlags,FlagWriteE,PCSrcE,RegWriteE,
                MemWriteE,PCS,RegWriteE2,MemWriteE2);
    
    //
    flopr #(1) ffCE1(clk,reset,PCS,PCSrcM);
    flopr #(1) ffCE2(clk,reset,RegWriteE2,RegWriteM);
    flopr #(1) ffCE3(clk,reset,MemtoRegE,MemtoRegM);
    flopr #(1) ffCE4(clk,reset,MemWriteE2,MemWriteM);
    
    //
    flopr #(1) ffCM1(clk,reset,PCSrcM,PCSrcW);
    flopr #(1) ffCM2(clk,reset,RegWriteM,RegWriteW);
    flopr #(1) ffCM3(clk,reset,MemtoRegM,MemtoRegW);
                    
    //DataPath-----------------------------------------------------------------------------
    logic [31:0] PCNext,PCPlus4;
    logic [31:0] ExtImm,ExtImmE,SrcA,SrcB,SrcAE,SrcAE1,Result,WriteDataE,WriteData,WriteDataE1;
    logic [3:0] RA1,RA2,WA3W,WA3E,WA3M,RA1E,RA2E;
    logic [31:0] PC,InstrF,InstrD,ALUOutW,ReadDataW,ReadData,ALUResult;
    
    //Hazard_Unit--------------------------------------------------------------------------
    logic [1:0] ForwardAE, ForwardBE;
    Hazard_Unit HU(RegWriteM, RegWriteW,MemtoRegE,RA1E,RA2E,RA1,RA2,WA3M,WA3W,WA3E,ForwardAE,ForwardBE,StallF,StallD,FlushE);
    
    //Fetch
    mux2 #(32) pcmux(PCPlus4,Result,PCSrcW,PCNext);
    flopenr #(32) pcreg(clk,reset,~StallF,PCNext,PC);
    adder #(32) pcadd1(PC,32'b100,PCPlus4);
    imem imem(PC,InstrF);
    
    flopenr #(32) ffFetch1(clk,reset,~StallD,InstrF,InstrD);
    
    //Decode
    mux2 #(4) ra1mux(InstrD[19:16],4'b1111,RegSrc[0],RA1);
    mux2 #(4) ra2mux(InstrD[3:0],InstrD[15:12],RegSrc[1],RA2);
    regfile rf(clk,RegWriteW,RA1,RA2,WA3W,Result,PCPlus4,SrcA,WriteData);
    extend ext(InstrD[23:0],ImmSrc,ExtImm);
    
    flopr #(32) ffDecode1(clk,FlushE,SrcA,SrcAE1);
    flopr #(32) ffDecode2(clk,FlushE,WriteData,WriteDataE1);
    flopr #(4) ffDecode3(clk,FlushE,InstrD[15:12],WA3E);
    flopr #(32) ffDecode4(clk,FlushE,ExtImm,ExtImmE);
    
    flopr #(4) ffDecode5(clk,reset,RA1,RA1E);
    flopr #(4) ffDecode6(clk,reset,RA2,RA2E);
    
    //Execute
    mux4  FAE(SrcAE1, Result, ALUOutM, 32'd0, ForwardAE, SrcAE);
    mux4  FBE(WriteDataE1, Result, ALUOutM, 32'd0, ForwardBE, WriteDataE);
    
    mux2 #(32) srcbmux(WriteDataE,ExtImmE,ALUSrcE,SrcB);
    ALU_ref #(32) alu(SrcAE,SrcB,ALUControlE,ALUResult,ALUFlags);
    
    flopr #(32) ffexe1(clk,reset,ALUResult,ALUOutM);
    flopr #(32) ffexe2(clk,reset,WriteDataE,WriteDataM);
    flopr #(4) ffexe3(clk,reset,WA3E,WA3M);
    
    //Memory
    dmem dmem(clk,MemWriteM,ALUOutM,WriteDataM,ReadData);
    
    flopr #(32) ffmem1(clk,reset,ReadData,ReadDataW);
    flopr #(32) ffmem2(clk,reset,ALUOutM,ALUOutW);
    flopr #(4) ffmem3(clk,reset,WA3M,WA3W);
    
    //Write Back
    mux2 #(32) resmux(ALUOutW,ReadDataW,MemtoRegW,Result);
    
        
endmodule