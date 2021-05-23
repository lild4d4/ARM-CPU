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
    input logic RegWriteM, RegWriteW,MemtoRegE,
    input logic [3:0] RA1E,RA2E,RA1D,RA2D,
    input logic [3:0] WA3M,WA3W,WA3E,
    input logic BranchTakenE,PCSrcD, PCSrcE, PCSrcM,PCSrcW,
    output logic [1:0] ForwardAE, ForwardBE,
    output logic StallF, StallD, FlushE, FlushD
    );
    
    logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E, LDRstall;
    logic PCWrPendingF;
    
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
    
    assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM; //no funciona cuando esta implementado ???????????????
    
    //Solving Data Hazards with stalls
    assign Match_12D_E = (RA1D==WA3E)|(RA2D==WA3E);
    assign LDRstall = Match_12D_E && MemtoRegE;
    assign StallF = LDRstall;
    assign StallD = LDRstall;
    assign FlushE = LDRstall | BranchTakenE;
    
    //Solving control hazards
    
    assign FlushD = PCSrcW | BranchTakenE;
    
    
    
endmodule
