`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 10:19:14
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] input1,
    input [31:0] input2,
    input [4:0] aluCtr,
    output zero,
    output [31:0] aluRes
    );
    reg Zero;
    reg [31:0] ALURes;
    
    // 00010 | Add
    // 00110 | Sub
    // 00000 | And
    // 00001 | Or
    // 01100 | xor
    // 01101 | nor
    // 00111 | slt
    // 00100 | sltu
    // 01000 | sll
    // 01001 | srl
    // 01010 | sra
    // 01011 | sllv
    // 00011 | srlv
    // 00101 | srav
    // 01111 | jr
    // 10000 | lui
    always @ (input1 or input2 or aluCtr)
    begin
        case (aluCtr)
        5'b00010 : ALURes = input1 + input2;
        5'b00110 : ALURes = input1 - input2;
        5'b00000 : ALURes = input1 & input2;
        5'b00001 : ALURes = input1 | input2;
        5'b01100 : ALURes = input1 ^ input2;
        5'b01101 : ALURes = ~(input1 | input2);
        5'b01000 : ALURes = input2 << input1[10:6];
        5'b01001 : ALURes = input2 >> input1[10:6];
        5'b01010 : ALURes = input2 >>> input1[10:6];
        5'b01011 : ALURes = input2 << input1;
        5'b00011 : ALURes = input2 >> input1;
        5'b00101 : ALURes = input2 >>> input1;
        5'b01111 : ALURes = input1;
        5'b10000 : ALURes = input2 * 65536;
        5'b00100 :
        begin
            if (input1 < input2)
                ALURes = 1;
            else
                ALURes = 0;
        end
        4'b00111 :
        begin
            if (input1 < 32'h80000000 && input2 < 32'h80000000)
                ALURes = (input1<input2) ? 1 : 0;
            else if (input1 < 32'h8000000)
                ALURes = 0;
            else if (input2 < 32'h8000000)
                ALURes = 1;
            else ALURes = (input1 > input2) ? 1: 0;
        end
        endcase
         if (ALURes == 0)
                Zero = 1;
            else 
                Zero = 0;
    end
    assign zero = Zero;
    assign aluRes = ALURes;
endmodule
