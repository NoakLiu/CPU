module alu(clk, op, in1, in2, alu_enable, out);

    `include "parameters.vh"

    input wire [3:0] op;
    input wire [WORD_SIZE-1:0] in1, in2;
    input wire clk, alu_enable;
    output reg [2*WORD_SIZE-1:0] out;
    
    reg[15:0] tempa;
    reg[15:0] tempb;
    reg[31:0] temp_a;
    reg[31:0] temp_b;
    integer i;
    reg [15:0] yshang;
    reg [15:0] yyushu;
    reg[1:0] ybmp;
    reg [WORD_SIZE-1:0] i1, i2;
    reg overflow;
    reg cout;
    reg borrow;
  
     task one_bit_adder;
        input  a,b,cin;
        output  sum,cout;
        reg [1:0] tmp;
        begin
            assign sum = a+b+cin;
            assign tmp = a+b+cin;
            assign cout = tmp[1];
            end
    endtask;
    
     task my_sixteen_bit_adder;
        parameter N=WORD_SIZE;
        input[N-1:0] a,b;
        input cin;
        output[N-1:0] sum;
        output cout,overflow;
        reg c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15;
        begin
        
        one_bit_adder(a[0],b[0],cin,sum[0],c1);
        one_bit_adder(a[1],b[1],c1,sum[1],c2);
        one_bit_adder(a[2],b[2],c2,sum[2],c3);
        one_bit_adder(a[3],b[3],c3,sum[3],c4);
        one_bit_adder(a[4],b[4],c4,sum[4],c5);
        one_bit_adder(a[5],b[5],c5,sum[5],c6);
        one_bit_adder(a[6],b[6],c6,sum[6],c7);
        one_bit_adder(a[7],b[7],c7,sum[7],c8);
        one_bit_adder(a[8],b[8],c8,sum[8],c9);
        one_bit_adder(a[9],b[9],c9,sum[9],c10);
        one_bit_adder(a[10],b[10],c10,sum[10],c11);
        one_bit_adder(a[11],b[11],c11,sum[11],c12);
        one_bit_adder(a[12],b[12],c12,sum[12],c13);
        one_bit_adder(a[13],b[13],c13,sum[13],c14);
        one_bit_adder(a[14],b[14],c14,sum[14],c15);
        one_bit_adder(a[15],b[15],c15,sum[15],cout);
        
        assign overflow = (a[15]&b[15]&~sum[15])|(~a[15]&~b[15]&sum[15]);
        end
        
    endtask

    task my_sub;
      parameter N=WORD_SIZE;
    
      input[N-1:0] x;
      input[N-1:0] y;
      output[N-1:0] d; 
      output borrow; 
      reg [N:0] bw;
      integer i;
       begin
            bw[0] = 1'b0;
             for(i = 0; i < N; i = i + 1) begin
               d[i] = x[i]^y[i]^bw[i];
                bw[i+1] = (~x[i]&(y[i]^bw[i]))|(y[i]&bw[i]);
             end
             borrow = bw[N];
        end
    endtask
    
    task my_multi;
        parameter N=WORD_SIZE;
        input [N-1:0] a;
        input [N-1:0] b;
        output [2*N-1:0] out;
        reg [2*N-1:0] an;
        reg [N-1:0] bn;
        reg [2*N-1:0] out;
     begin  
            begin
                out=16'b0;
                an=a;
                bn=b;
                repeat(N)
                begin
                    if(bn[0]) out=out+an;
                    else out=out;
                    an=an<<1;
                    bn=bn>>1;
                end
            end
            end
      endtask

    task my_slt;
    input [15:0] a,b;
        output [15:0] out;
        integer i;
        integer flag;
        begin
            for(i = 15;i >= 1;i = i - 1)
            begin
                out[i] = 1'h0;
            end
            out[0]=1'h1;
            i1<=a;
            i2<=b;
            flag=1;
            for(i = 15;i >= 0;i = i - 1)//由高位向低位进行比较
              begin
                if(a[i]>b[i]&&flag)
                begin
                    flag=0;
                 end;
              end;
              if(!flag)
              begin
                  out[0]<=1'h0;
              end
              out={out[7:1],flag};
       end
    endtask
    
    task my_and;
        input [15:0] a,b;
        output [15:0] out;
        integer i;
        begin
            for(i = 15;i >= 0;i = i - 1)
              out[i] = a[i] & b[i];//按位与
            end
    endtask
    
    task my_or;
        input [15:0] a,b;
        output [15:0] out;
        integer i;
        begin
            for(i = 15;i >= 0;i = i - 1)
              out[i] = a[i] | b[i];
            end
    endtask
    
    task my_xor;
        input [15:0] a,b;
        output [15:0] out;
        integer i;
        begin
            for(i = 15;i >= 0;i = i - 1)
              out[i] = a[i] ^ b[i];
            end
    endtask
    
    task my_shift;
        input [15:0] a,b;
        output [15:0] out;
        integer i;
        begin
            if(b>=0)//左移
            begin
                for(i=15;i>=b;i=i-1)
                out[i]=a[i-b];
                for(i=b-1;i>=0;i=i-1)
                out[i]=0;
            end
            if(b<0)//右移
            begin
                for(i=15+b;i>=0;i=i-1)
                out[i]=a[i-b];
                for(i=15;i>15+b;i=i-1)
                out[i]=0;
            end
        end
     endtask
    
    task div_task;
        input   rst,enable;
        input [15:0]  a,b;
        output[15:0]  shang,yushu;
        
        reg [15:0] temp_a1,temp_b1;
        reg [31:0] temp_a2,temp_b2;  
         integer i;
         begin

            if(!rst)
            begin
              temp_a1 = 16'h0;
              temp_b1 = 16'h0;
            end
            else if(enable)             //赋初值
            begin
               temp_a1 = a;
               temp_b1 = b;
            end
            else
             begin
                temp_a1 = temp_a1;
                temp_b1 = temp_b1;
              end

            if(!rst)
            begin
              temp_a2 = 32'h0;
              temp_b2 = 32'h0;
            end
            else 
            begin
               temp_a2 = {16'h0,temp_a1};
               temp_b2 = {temp_b1,16'h0};
               for(i = 0; i < 16; i = i+1)         //除数左移位16次
                  begin
                     temp_a2 = {temp_a2[30:0],1'b0}  ;
                     if(temp_a2[31:16] >= temp_b2[31:16] )
                        temp_a2 = temp_a2 - temp_b2 + 1;
                     else
                        temp_a2 = temp_a2;
                  end                      
           end
          assign shang = temp_a2[15:0];//商在低位
          assign yushu = temp_a2[31:16];//余数在高位
          end
    endtask
    always @(*) begin//此处对clock做出调整
        if (alu_enable) begin
            case (op)
                `ALU_ADD:
                    //out <= in1 + in2;
                    my_sixteen_bit_adder(.a(in1),.b(in2),.cin(0),.sum(out),.cout(cout),.overflow(overflow));
                `ALU_SUB:
                    //out <= in1 - in2;
                    my_sub(.x(in1),.y(in2),.d(out),.borrow(borrow));
                `ALU_MUL:
                    //out <= in1 * in2;
                    my_multi(.a(in1),.b(in2),.out(out));
                `ALU_SLT:
                    //out <= in1 < in2;
                    my_slt(.a(in1),.b(in2),.out(out));
                `ALU_AND:
                    //out <= in1 & in2;
                    my_and(.a(in1),.b(in2),.out(out));
                `ALU_OR:
                    //out <= in1 | in2;
                    my_or(.a(in1),.b(in2),.out(out));
                `ALU_XOR:
                    //out <= in1 ^ in2;
                    my_xor(.a(in1),.b(in2),.out(out));
                `ALU_SHIFT:
                    //out <= in1 << in2;
                    my_shift(.a(in1),.b(in2),.out(out));
                `ALU_DIV:
                    //out<=in1/in2;
                    div_task(.a(in1),.b(in2),.shang(out),.yushu(yyushu),.enable(1), .rst(1));
            endcase
        end
    end

endmodule