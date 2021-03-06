`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 11:37:58
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
    input Clk,
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output reg [31:0] readData
    );
    reg [31:0] memFile[0:63];
    
    initial begin
        $readmemh("C:/Archlabs/0467+ljj+lab6/lab6.srcs/sources_1/data", memFile);
    end
    
    always @ (memRead or address or memWrite)
    begin
        if (memRead == 1)
            readData = memFile[address];
    end
    
    always @ (negedge Clk)
    begin
        if (memWrite == 1)
        begin
            memFile[address] = writeData;
            if (memRead == 1)
                readData = memFile[address]; 
        end
    end
endmodule
