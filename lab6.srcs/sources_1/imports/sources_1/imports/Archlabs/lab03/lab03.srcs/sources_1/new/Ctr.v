`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 07:58:25
// Design Name: 
// Module Name: Ctr
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


module Ctr(
    input reset,
    input [5:0] opCode,
    input [5:0] funct,
    output regDst,
    output aluSrc,
    output memToReg,
    output regWrite,
    output memRead,
    output memWrite,
    output [1:0]branch,
    output [3:0] aluOp,
    output jump,
    output reg shift
    );
    reg RegDst;
    reg ALUSrc;
    reg MemToReg;
    reg RegWrite;
    reg MemRead;
    reg MemWrite;
    reg [1:0]Branch;
    reg [3:0] ALUOp;
    reg Jump;
    
    
    
    always @(opCode or funct or reset)
    begin
        if (reset == 1)
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
            shift = 0;
        end
        else
        begin
        case(opCode)
        6'b000000:  // R-format
        begin
            RegDst = 1;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0100;
            Jump = 0;
            shift = 0;
            if(funct == 6'b000000 || funct == 6'b000010 || funct == 6'b000011)
                shift = 1;
            if(funct == 6'b001000)
            begin
                RegWrite = 0;
                Jump = 1;
            end
        end
        6'b100011:  // lw
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
            shift = 0;
        end
        6'b101011:  // sw
        begin
            //regDst = X;
            ALUSrc = 1;
            //memToReg = X;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
            shift = 0;
        end
        6'b000100:  // beq
        begin
            //regDst = X;
            ALUSrc = 0;
            //memToReg = X;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 2'b01;
            ALUOp = 4'b0001;
            Jump = 0;
            shift = 0;
        end
        6'b000101:  // bne
        begin
            //regDst = X;
            ALUSrc = 0;
            //memToReg = X;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 2'b11;
            ALUOp = 4'b0001;
            Jump = 0;
            shift = 0;
        end
        6'b000010:  // j
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 1;
            shift = 0;
        end
        6'b000011:  // jal
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 1;
            shift = 0;
        end
        6'b001100:  // andi
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0011;
            Jump = 0;
            shift = 0;
        end
        6'b001101:  // ori
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0010;
            Jump = 0;
            shift = 0;
        end
        6'b001110:  // xori
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0101;
            Jump = 0;
            shift = 0;
        end
        6'b001000:  // addi
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
            shift = 0;
        end
        6'b001001:  // addiu
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
            shift = 0;
        end
        6'b001111:  //lui
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0110;
            Jump = 0;
            shift = 0;
        end
        6'b001010:  // slti
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0111;
            Jump = 0;
            shift = 0;
        end
        6'b001011:  // sltiu
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b1000;
            Jump = 0;
            shift = 0;
        end
        default:
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 2'b00;
            Jump = 0;
            shift = 0;
        end
    endcase
    end
    end
    assign regDst = RegDst;
    assign aluSrc = ALUSrc;
    assign memToReg = MemToReg;
    assign regWrite = RegWrite;
    assign memRead = MemRead;
    assign memWrite = MemWrite;
    assign branch = Branch;
    assign aluOp = ALUOp;
    assign jump = Jump;
    
endmodule
