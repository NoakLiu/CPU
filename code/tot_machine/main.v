module main;

    /* 
     * Main module for CPU.  Contains the CPU module and connects it to other simulated hardware devices.
     */
    
    reg clk = 1;
    always #5 clk = !clk;
    
    always @(negedge clk)
        $display("-----");
    
    wire [7:0] sw;
    //assign sw =8'b00000001;//8
    
    wire [3:0] btn;
    //assign btn = 4'b0000;//4
    
    wire [7:0] led;
    wire [3:0] an;
    wire dp;
    wire [6:0] seg;
    
    wire usb_write ;
    wire usb_astb ;
    wire usb_dstb ;
    wire usb_wait;
    wire [7:0] usb_db;
    
    wire [0:14] machdb [0:3];
    assign machdb[0]={8'b00000001,4'b0000,1'b1,1'b1,1'b1};
    assign machdb[1]={8'b00000010,4'b0001,1'b1,1'b0,1'b0};
    assign machdb[2]={8'b00000011,4'b0010,1'b0,1'b1,1'b0};
    assign machdb[3]={8'b00000100,4'b0011,1'b0,1'b0,1'b1};
    
    integer num=0;
    assign {sw,btn,usb_write,usb_astb,usb_dstb}=machdb[num];
    
    
    machine machine(clk, sw, btn, led,
        an, dp, seg,
        usb_write, usb_astb, usb_dstb, usb_db, usb_wait
        );
    
    always @(posedge clk) begin
        if(num<3)
        $display("led %b", led);
        else
        $stop;
        num=num+1;
    end

endmodule
