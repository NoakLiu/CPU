`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 21:51:23
// Design Name: 
// Module Name: io_test
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
`include "parameters.vh"
module io_test;
reg clk = 0;
begin
    always #5 clk = !clk;
end

wire [3:0] btn;//port为buttion情况下调用 input 4
wire [7:0] sw;//port为switch情况下调用 input 8
wire [3:0] led;//output
wire [31:0] ssd_bits ;//= 32'hFFFFFFFF;//output
wire ssd_char_mode ;//= 0;//output

wire port_read;//bool input 1
wire port_write;//bool input 1
wire [15:0] port_addr;//从para中查看 input 16
wire [15:0] port_write_data;//可以分为4段，16位二进制数 input 16
wire [15:0] port_read_data;//output

wire [0:45] iodata [0:2];//btn sw port_read port_write port_addr port_write_data 4+8+1+1+16+16=46

io_driver io_driver(clk,
    sw, btn, led,
    ssd_bits, ssd_char_mode,
    port_read, port_write, port_addr, port_write_data, port_read_data
);


//assign iodata[0] = {4'b1,8'b00000001,1'b1,1'b1,`PORT_IO_CHAR,16'h0001};
assign iodata[0] = {4'b1,8'b00000101,1'b1,1'b1,`PORT_IO_LED,16'h0003};
assign iodata[1] = {4'b1,8'b00000001,1'b1,1'b1,`PORT_IO_CHAR,16'h0001};
//assign iodata[1] = {4'd0,8'd7,1'd0,1'd1,16'd5,16'd9};
assign iodata[2] = {4'd3,8'd2,1'd1,1'd0,16'd13,16'd2};
reg clk = 0;
    begin
        always #5 clk = !clk;
    end
reg num=0;
always @(posedge clk) 
   begin
        if (num <1)
            $display("btn=%d sw=%d port_read=%d port_write=%d port_addr=%d port_write_data=%d ssd_bits=%x ssd_char_mode=&d",
                    btn,sw,port_read,port_write,port_addr,port_write_data,ssd_bits,ssd_char_mode);
        else
            $stop;
        num <= num + 1;
    end
assign {btn,sw,port_read,port_write,port_addr,port_write_data}=iodata[num];

endmodule
