`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2020 13:29:32
// Design Name: 
// Module Name: decoder
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


module decoder(
    input logic [1:0] Op,
    input logic [5:0] Funct,
    input logic [3:0] Rd,
    output logic [1:0] FlagW,
    output logic PCS, RegW, MemW,
    output logic MemtoReg, ALUSrc,
    output logic [1:0] ImmSrc, RegSrc, ALUControl
    );
    
    logic [9:0] controls;
    logic Branch, ALUOp;
   
    //main decoder
    always_comb begin
        casex(Op)                   
            2'b00: if (Funct[5]) controls = 10'b0000101001; //Data-processing immediate
                        
                   else controls = 10'b0000001001;          //Data-processing register
                   
            2'b01: if (Funct[0]) controls = 10'b0001111000; //LDR
            
                   else controls = 10'b1001110100;          //STR
                   
            2'b10: controls = 10'b0110100010;
            
            default: controls = 10'bx;                      //Unimplemented
                   
        endcase
    end
    
    assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
    
    always_comb begin
        if (ALUOp) begin 
            case(Funct[4:1])
                4'b0100: ALUControl = 2'b00; //ADD
                4'b0010: ALUControl = 2'b01; //SUB
                4'b0000: ALUControl = 2'b11; //AND
                4'b1100: ALUControl = 2'b10; //ORR
                default: ALUControl = 2'bx;  //Unimplemented
            endcase
            
        //update flags if S bit is set (C & V only for arith)
        FlagW[1] = Funct[0];
        FlagW[0] = Funct[0]&(ALUControl == 2'b00 | ALUControl == 2'b01);
        end
        
        else begin
            ALUControl = 2'b00; //add for non-DP instructions
            FlagW = 2'b00;      //don't update flags
        end   
    end
    
    //PC logic 
    assign PCS = ((Rd == 4'b1111)&RegW)|Branch;
    
endmodule
