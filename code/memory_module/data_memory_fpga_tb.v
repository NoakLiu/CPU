    module mem_main;
    
    //output wire [3:0] an;
    //output wire dp;
    //output wire [6:0] seg;
    
    wire [3:0] an;
    wire dp;
    wire [6:0] seg;
    reg mclk=0;

    //define clock 
    begin
     always   #50 mclk = ~mclk;
    end

    //Stimulus for RESET and STARTSTOP
    /*initial begin
        #50 mclk = 0;
    end*/

    `include "parameters.vh"

    parameter GET = 1'b1;
    parameter SET = 1'b1;
    parameter X = 1'b0;
    
    reg [3:0] num = 0;
    always @(posedge mclk) begin
        if(num<7)
            num <= num + 1;
        else
            $stop;
    end

    wire [WORD_SIZE + WORD_SIZE + 1 + 1 + WORD_SIZE - 1:0] data [0:7];
    assign data[0] = { 16'h1, 16'h1, X, SET, 16'h0 };
    assign data[1] = { 16'h2, 16'h4, X, SET, 16'h0 };
    assign data[2] = { 16'h3, 16'h9, X, SET, 16'h0 };
    assign data[3] = { 16'h0, 16'h1, X, X, 16'h0 };
    assign data[4] = { 16'h0, 16'h3, X, X, 16'h0 };
    assign data[5] = { 16'h1, 16'h8, GET, X, 16'h1 };
    assign data[6] = { 16'h2, 16'h1, GET, X, 16'h4 };
    assign data[7] = { 16'h3, 16'h2, GET, X, 16'h9 };
    
    wire [15:0] memaddr;
    wire [15:0] memval;
    wire memget;
    wire memset;
    wire [15:0] expected_memout;
    wire [15:0] memout;
    assign { memaddr, memval, memget, memset, expected_memout } = data[num];
    

    data_memory data_memory(mclk, memaddr, memval, memget, memset, memout);
    
    wire [15:0] show_delta = memout - expected_memout;
    ssd_driver ssd(mclk, an, seg, dp,show_val,1);

endmodule
