`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 09:25:27
// Design Name: 
// Module Name: ALUCtr
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


module ALUCtr(
    input [5:0] funct,
    input [3:0] aluOp,
    output [4:0] aluCtrOut
    );
    reg [3:0] ALUCtrOut;
    
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
    
    always @ (aluOp or funct)
    begin
        case (aluOp)
        4'b0100:
        begin
            case (funct)
            6'b100000 : ALUCtrOut = 5'b00010;
            6'b100001 : ALUCtrOut = 5'b00010;
            6'b100010 : ALUCtrOut = 5'b00110;
            6'b100010 : ALUCtrOut = 5'b00110;
            6'b100100 : ALUCtrOut = 5'b00000;    // AND
            6'b100101 : ALUCtrOut = 5'b00001;    // OR
            6'b100110 : ALUCtrOut = 5'b01100;    // XOR
            6'b100111 : ALUCtrOut = 5'b01101;    // NOR
            6'b101010 : ALUCtrOut = 5'b00111;    // SLT
            6'b101011 : ALUCtrOut = 5'b00100;    // SLTU
            6'b000000 : ALUCtrOut = 5'b01000;    // SLL
            6'b000100 : ALUCtrOut = 5'b01011;    // SLLV
            6'b000010 : ALUCtrOut = 5'b01001;    // SRL
            6'b000110 : ALUCtrOut = 5'b00011;    // SRLV
            6'b000011 : ALUCtrOut = 5'b01010;    // SRA
            6'b000111 : ALUCtrOut = 5'b00101;    // SRAV
            6'b001000 : ALUCtrOut = 5'b01111;    // JR
            endcase
        end
        4'b0000 : ALUCtrOut = 5'b00010;
        4'b0001 : ALUCtrOut = 5'b00110;
        4'b0011 : ALUCtrOut = 5'b00000;
        4'b0010 : ALUCtrOut = 5'b00001;
        4'b0101 : ALUCtrOut = 5'b01100;
        4'b0110 : ALUCtrOut = 5'b10000;
        4'b0111 : ALUCtrOut = 5'b00111;
        4'b1000 : ALUCtrOut = 5'b00100;
        endcase
    end
    assign aluCtrOut = ALUCtrOut;
endmodule
