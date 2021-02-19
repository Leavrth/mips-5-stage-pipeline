`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 11:04:09
// Design Name: 
// Module Name: Registers
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


module Registers(
    input Clk,
    input Reset,
    input [25:21] readReg1,
    input [20:16] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    input regWrite,
    output reg [31:0] readData1,
    output reg [31:0] readData2
    );
    
    reg [31:0] regFile[0:31];
    
    
    
    
    always @ (readReg1 or readReg2 or writeReg or regWrite)
    begin
            readData1 = regFile[readReg1];
            readData2 = regFile[readReg2];
    end
    
    integer i;
    always @ (negedge Clk or posedge Reset)
    begin
        if(Reset == 1)
            for (i=0;i<32;i=i+1) regFile[i]<=8'h00000000;
        else
        if (regWrite == 1)
            regFile[writeReg] = writeData;
        // 可能读写寄存器相同，因此再修改后更新主动一下
        readData1 = regFile[readReg1];
        readData2 = regFile[readReg2];
    end
endmodule
