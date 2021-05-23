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

//HOLAAAAAAAAAA

module imem(
    input logic [31:0] a,
    output logic [31:0] rd
    );
    
    logic [31:0] RAM[80:0];
    
    initial
        $readmemh("memfilePipeNop.mem",RAM);
        
    assign rd = RAM[a[31:2]]; //word aligned
    
endmodule
