`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/07 16:23:53
// Design Name: 
// Module Name: reg_stack_tb
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


module reg_stack_tb;

/*
input wire [NIB_SIZE-1:0] num1, num2, setnum; 4*3
input wire [WORD_SIZE-1:0] setval; 16*1
input wire clk;
input wire get_enable, set_enable, reset_enable; 1*3
output reg [WORD_SIZE-1:0] out1, out2;
*/

`include "parameters.vh"

reg clk = 0;
    begin
        always #5 clk = !clk;
    end
reg num=0;
always @(posedge clk) 
begin
    if (num >=1)
        $stop;
    num <= num + 1;
end

wire [0:30] rsdata [0:3];//num1 4, num2 4, setnum 4, setval 16, get_enable 1, set_enable 1, reset_enable 1
assign rsdata[0] = {4'b1001,4'b1010,16'b1010111101010011,1'b1,1'b0,1'b0};
assign rsdata[1] = {4'b1001,4'b1010,16'b1010111101010011,1'b0,1'b1,1'b0};
assign rsdata[2] = {4'b1001,4'b1010,16'b1010111101010011,1'b0,1'b0,1'b1};

wire [NIB_SIZE-1:0] num1, num2, setnum;
wire [WORD_SIZE-1:0] setval; 
wire get_enable, set_enable, reset_enable;
wire [WORD_SIZE-1:0] out1, out2;

assign {num1,num2,setnum,setval,get_enable,set_enable,reset_enable}=rsdata[num];

reg_stack rs(clk, num1, num2, setnum, setval, get_enable, set_enable, reset_enable, out1, out2);

endmodule
