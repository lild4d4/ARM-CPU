`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2020 13:03:09
// Design Name: 
// Module Name: dmem
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


module dmem(
    input logic clk,we,
    input logic [31:0] a,wd,
    output logic [31:0] rd
    );
    
    logic [31:0] RAM[100:0];
    
    assign rd=RAM[a[31:2]]; //word aligned (se elimina el 00 final )
    
    always_ff@(posedge clk)
        if (we) RAM[a[31:2]]<=wd;
    
endmodule
