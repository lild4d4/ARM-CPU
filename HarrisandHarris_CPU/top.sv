`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2020 21:54:45
// Design Name: 
// Module Name: top
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


module top(
    input logic clk, reset,
    output logic [31:0] WriteData, DataAdr,
    output logic MemWrite
    );
    
    logic [31:0] PC,Instr,ReadData;
    
    //instantiate processor memories
    arm arm(clk,reset,PC,Instr,MemWrite,DataAdr,WriteData,ReadData);
    
    imem imem(PC,Instr);
    dmem dmem(clk,MemWrite,DataAdr,WriteData,ReadData);
        
endmodule
