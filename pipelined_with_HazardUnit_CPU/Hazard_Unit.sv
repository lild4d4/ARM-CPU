`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.12.2020 12:58:10
// Design Name: 
// Module Name: Hazard_Unit
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


module Hazard_Unit(
    input logic RegWriteM, RegWriteW,
    input logic [3:0] RA1E,RA2E,
    input logic [3:0] WA3M,WA3W,
    output logic [1:0] ForwardAE, ForwardBE
    );
    
    logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W;
    
    //solving data hazards with forwarding
    assign Match_1E_M = (RA1E == WA3M);
    assign Match_1E_W = (RA1E == WA3W);
    assign Match_2E_M = (RA2E == WA3M);
    assign Match_2E_W = (RA2E == WA3W);
    
    always_comb begin
    
        if (Match_1E_M && RegWriteM) ForwardAE = 2'b10;
        
        else if (Match_1E_W && RegWriteW) ForwardAE = 2'b01;
        
        else ForwardAE = 2'b00;
    
        if (Match_2E_M && RegWriteM) ForwardBE = 2'b10;
        
        else if (Match_2E_W && RegWriteW) ForwardBE = 2'b01;
        
        else ForwardBE = 2'b00;
    
    end
    
endmodule
