module reg_stack(clk, num1, num2, setnum, setval, get_enable, set_enable, reset_enable, out1, out2);

    /* Register stack
     *
     * This module contains a set of registers, each of size WORD_SIZE,
     * addressed by values of size NIB_SIZE.  Two registers can be loaded
     * from it in a clock cycle.  These will be cached in regs.
     *
     * Action takes place when clk goes high.
     *
     * Set get_enable to get num1 as out1, and num2 as out2.
     * Set set_enable to set setnum as setval.
     * Set reset_enable to reset all registers to zero.
     */

    `include "parameters.vh"

    input wire [NIB_SIZE-1:0] num1, num2, setnum;
    input wire [WORD_SIZE-1:0] setval;
    input wire clk;
    input wire get_enable, set_enable, reset_enable;
    output reg [WORD_SIZE-1:0] out1=16'h0, out2=16'h0;

    reg [WORD_SIZE-1:0] data [0:REG_STACK_SIZE-1];//16*16 matrix
    initial begin
        data[0]=16'h0;
        data[1]=16'h1;
        data[2]=16'h2;
        data[3]=16'h3;
        data[4]=16'h4;
        data[5]=16'h5;
        data[6]=16'h6;
        data[7]=16'h7;
        data[8]=16'h8;
        data[9]=16'h9;
        data[10]=16'ha;
        data[11]=16'hb;
        data[12]=16'hc;
        data[13]=16'hd;
        data[14]=16'he;
        data[15]=16'hf;
    end

    integer i;

    always @(posedge clk) begin
        if (reset_enable) begin
            for (i = 0; i < REG_STACK_SIZE; i = i+1) begin
                data[i] <= 0;
            end
        end if (get_enable) begin
            out1 <= data[num1];
            out2 <= data[num2];
        end else if (set_enable) begin
            $display("reg %d set to %d", setnum, setval);
            data[setnum] <= setval;
        end
    end

endmodule
