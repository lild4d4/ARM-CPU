`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2020 21:19:51
// Design Name: 
// Module Name: extend
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


module extend(
    input logic [23:0] Instr,
    input logic [1:0] ImmSrc,
    output logic [31:0] ExtImm
    );
    always_comb begin
        case(ImmSrc)
                            //8-bit unsigned immediate
            2'b00: ExtImm = {24'b0, Instr[7:0]};
                            //12-bit unsigned immediate
            2'b01: ExtImm = {20'b0, Instr[11:0]};
                            //24-bit two's complement shifted branch 
            2'b10: ExtImm = {{6{Instr[23]}}, Instr[23:0],2'b00};
                            
            default: ExtImm = 32'bx;
        endcase
    end
    
    
endmodule
