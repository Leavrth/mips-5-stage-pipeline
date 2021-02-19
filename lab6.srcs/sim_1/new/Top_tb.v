`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/10 14:59:44
// Design Name: 
// Module Name: Top_tb
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


module Top_tb(

    );
    reg clock;
    reg reset;
    
    Top top(
        .Clk(clock),
        .Reset(reset)
    );
    
    parameter PERIOD = 10;
    
    always #(PERIOD * 2) clock = !clock;
    
    initial begin
    clock = 1'b0;
    reset = 1'b0;
    
    #10;
    reset=1;
    #20;
    reset=0;
    
    end
    
endmodule
