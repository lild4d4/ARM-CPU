`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2020 17:37:51
// Design Name: 
// Module Name: condlogic
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


module condlogic(
    input logic clk, reset,
    input logic [3:0] Cond,
    input logic [3:0] ALUFlags,
    input logic [1:0] FlagW,
    input logic PCS, RegW, MemW,
    output logic PCSrc, RegWrite, MemWrite
    );
    
    logic [1:0] FlagWrite;
    logic [3:0] Flags;
    logic CondEx;
    
    flopenr #(2)flagreg1(clk, reset, FlagWrite[1], ALUFlags[3:2], Flags[3:2]);
    flopenr #(2)flagreg0(clk, reset, FlagWrite[0], ALUFlags[1:0], Flags[1:0]);
    
    //write controls are conditional
    condcheck cc(Cond, Flags, CondEx);
    assign FlagWrite = FlagW & {2{CondEx}};
    assign RegWrite = RegW & CondEx;
    assign MemWrite = MemW & CondEx;
    assign PCSrc = PCS & CondEx;
      
endmodule

module condcheck(
    input logic [3:0] Cond,
    input logic [3:0] Flags,
    output logic CondEx
    );
    
    logic neg, Zero, carry, overflow, ge;
    
    assign {neg, zero, carry, overflow} = Flags;
    assign ge = (neg == overflow);
    
    always_comb begin
        case(Cond)
            4'b0000: CondEx = zero;
            4'b0001: CondEx = ~zero;
            4'b0010: CondEx = carry;
            4'b0011: CondEx = ~carry;
            4'b0100: CondEx = neg;
            4'b0101: CondEx = ~neg;
            4'b0110: CondEx = overflow;
            4'b0111: CondEx = ~overflow;
            4'b1000: CondEx = carry & ~zero;
            4'b1001: CondEx = ~(carry & ~zero);
            4'b1010: CondEx = ge;
            4'b1011: CondEx = ~ge;
            4'b1100: CondEx = ~zero & ge;
            4'b1101: CondEx = ~(~zero & ge);
            4'b1110: CondEx = 1'b1;
            default: CondEx = 1'bx;
       endcase
    end
endmodule
