`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2020 13:11:53
// Design Name: 
// Module Name: regfile
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


module regfile(
    input logic clk,
    input logic we3,
    input logic [3:0] ra1,ra2,wa3,
    input logic [31:0] wd3,r15,
    output logic [31:0] rd1,rd2
    );
    
    logic [31:0] rf[14:0];
    
    //three ported register file
    //read two ports combinationally
    //write third port on rising edge of clock
    //register 15 reads PC+8 instead
    
    always_ff@(posedge clk)
        if (we3) rf[wa3]<=wd3;
        
    assign rd1 = (ra1==4'b1111) ?r15:rf[ra1];
    assign rd2 = (ra2==4'b1111) ?r15:rf[ra2];    
    
endmodule
