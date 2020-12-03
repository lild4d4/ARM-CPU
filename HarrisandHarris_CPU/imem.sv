`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2020 20:55:06
// Design Name: 
// Module Name: imem
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


module imem(
    input logic [31:0] a,
    output logic [31:0] rd
    );
    
    logic [31:0] RAM[63:0];
    
    initial
        $readmemh("C:/Users/Daniel Arevalos/Desktop/VivadoProyects/HarrisAndHarris_ARM_SingleCore_CPU2/HarrisAndHarris_ARM_SingleCore_CPU2.srcs/sources_1/imports/HarrisAndHarris_ARM_SingleCore_CPU.srcs/sources_1/new/memfile.dat",RAM);
        
    assign rd = RAM[a[31:2]]; //word aligned
    
endmodule
