`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/24 08:06:32
// Design Name: 
// Module Name: InstMemory
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


module InstMemory(
    input [31:0] addr,
    output [31:0] inst
    );
    reg[31:0] INSTs[0:100];
    initial begin
        $readmemb("C:/Archlabs/0467+ljj+lab6/lab6.srcs/sources_1/Instruction", INSTs);
    end
    assign inst = INSTs[addr>>2];
endmodule
