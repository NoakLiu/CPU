module io_driver(clk,
    sw, btn, led,
    ssd_bits, ssd_char_mode,
    port_read, port_write, port_addr, port_write_data, port_read_data
);

    `include "parameters.vh"

    input wire clk;

    input wire [3:0] btn;//port为buttion情况下调用
    input wire [7:0] sw;//port为switch情况下调用
    output reg [3:0] led= 4'b0000;
    output reg [31:0] ssd_bits = 32'hFFFFFFFF;
    output reg ssd_char_mode = 1'b0;

    input wire port_read;//bool
    input wire port_write;//bool
    input wire [15:0] port_addr;//从para中查看
    input wire [15:0] port_write_data;//可以分为4段，16位二进制数
    output reg [15:0] port_read_data=4'd0;
    
    /* LEDs */
    always @(posedge clk) 
    begin
        if (port_write && port_addr == `PORT_IO_LED) begin
            led <= port_write_data[3:0];
        end
    end
    
    /* Seven segment display */
    wire [15:0] bcd;
    convert_to_bcd convert_to_bcd(port_write_data, bcd);
    //reg [15:0]tmpl;
    //reg [32:0]res;
   always @(posedge clk) begin
        //assign tmpl=ssd_bits[15:0];
        if (port_write && port_addr == `PORT_IO_HEX) begin
            $display("here is hex");
            ssd_bits = { 4'b0000, port_write_data[15:12], 4'b0000, port_write_data[11:8], 4'b0000, port_write_data[7:4], 4'b0000, port_write_data[3:0] };
            ssd_char_mode = 1;
        end else if (port_write && port_addr == `PORT_IO_DEC) begin
            $display("here is dec");
            ssd_bits <= { 4'b0000, bcd[15:12], 4'b0000, bcd[11:8], 4'b0000, bcd[7:4], 4'b0000, bcd[3:0] };
            ssd_char_mode <= 1;
        end else if (port_write && port_addr == `PORT_IO_CHAR) begin
            $display("here is char");
            $display("ssd_bits=%x",ssd_bits);
            $display("ssd bits[15:0]=%x",ssd_bits[15:0]);
            $display("port_write_data=%x",port_write_data);
            assign ssd_bits = { ssd_bits[15:0], port_write_data };
            $display("ssd_bits=%x",ssd_bits);
            $display("ssd bits[15:0]=%x",ssd_bits[15:0]);
            $display("port_write_data=%x",port_write_data);
            assign ssd_char_mode = 1;
            $display("ssd_char_modes=%d",ssd_char_mode);
        end else if (port_write && port_addr == `PORT_IO_BITS) begin
            $display("here is bits");
            ssd_bits <= { ssd_bits[15:0], port_write_data };
            ssd_char_mode <= 1'b0;
        end
        //assign ssd_bits=res;
        $display("final ssd_bits=%x",ssd_bits);
        $display("final ssd char_modes=%d",ssd_char_mode);
    end

    /* Switches and buttons */
    always @(posedge clk) begin
        port_read_data <= 0;
        if (port_read && port_addr == `PORT_IO_SWITCH) begin
            port_read_data <= { 8'h00, sw };
        end else if (port_read && port_addr == `PORT_IO_BUTTON) begin
            port_read_data <= { 12'h00, btn };
        end
    end

endmodule
