`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/05 17:11:54
// Design Name: 
// Module Name: control_test
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

module control_test;
    `include"parameters.vh"
    /*wire [0:2] op;
    wire [0:WORD_SIZE-1] in1, in2;
    wire [0:WORD_SIZE-1] expected;
    wire [0:WORD_SIZE-1] out;
    wire enable=1;
    reg clk = 0;
    begin
    always #5 clk = !clk;
    end
    wire [7:0] total = 8;
    reg [7:0] num = 0;
    module control;*/
    /*
    input wire clk;
    
    input wire [NIB_SIZE-1:0] opcode;
    input wire isaluop;
    
    input wire [7:0] bus_addr;
    input wire bus_read;
    input wire bus_write;
    input wire [7:0] bus_data;
    
    //assign bus_data = 8'bZZZZZZZZ;
    
    output wire do_fetch, do_regload, do_aluop, do_memload, do_memstore, do_regstore, do_next, do_reset;
    
    output reg [3:0] state = `STATE_INSMEM_LOAD;
    */
    reg clk = 0;
    begin
        always #5 clk = !clk;
    end
    //input
    wire [NIB_SIZE-1:0] opcode;//此处有9个opcode，所以需要4位
    wire isaluop = 0;
    reg [8:0] bus_data = 9'b001010111;
    wire [7:0] bus_addr = `CTRL_CPU_STATE;
    wire bus_read = 1;
    wire bus_write = 1;
    
    
    //output
    wire do_fetch, do_regload, do_aluop, do_memload, do_memstore, do_regstore, do_next, do_reset;
    wire [3:0] state ;//`define STATE_INSMEM_LOAD 4'h0
    
    control control1(clk,
    opcode, isaluop,
    bus_addr, bus_read, bus_write, bus_data,
    do_fetch, do_regload, do_aluop, do_memload, do_memstore, do_regstore, do_next, do_reset,
    state);
    wire [0:NIB_SIZE-1] data [0:8];
    /*
    assign data[0] = { `STATE_INSMEM_LOAD };//wire [0:2] op; input wire [WORD_SIZE-1:0] in1, in2; wire [0:WORD_SIZE-1] expected;
    assign data[1] = { `STATE_RESET};
    assign data[2] = { `STATE_FETCH};
    assign data[3] = { `STATE_REGLOAD};
    assign data[4] = { `STATE_ALUOP};
    assign data[5] = { `STATE_LOAD};
    assign data[6] = { `STATE_STORE};
    assign data[7] = { `STATE_REGSTORE};
    assign data[8] = {`STATE_NEXT};*/
    assign data[0]={`OP_LOAD};
    assign data[1]={`OP_STORE};
    assign data[2]={`OP_IN};
    assign data[3]={`OP_OUT};
    assign data[4]={`OP_JMP};
    assign data[5]={`OP_BR};
    assign data[6]={`OP_LOADLO};
    assign data[7]={`OP_LOADHI};
    reg [8:0] num = 0;
    assign { opcode } = data[num];
    
    wire [8:0] total = 9;
    always @(posedge clk) begin
        if (num < total)
            $display("do_fetch = %d, do_regload = %d, do_aluop = %d, do_memload = %d, do_memstore = %d, do_regstore = %d, do_nex=%d, do_reset=%d",
                    do_fetch, do_regload, do_aluop, do_memload, do_memstore, do_regstore, do_next, do_reset);
        else
            $stop;
        num <= num + 1;
    end
    
    
endmodule
