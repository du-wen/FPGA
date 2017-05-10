`timescale      1ns/1ns

module  tb_fifo;
reg         r_clk,w_clk;
reg         w_en;
reg  [7:0]  w_data;
reg         r_en;
wire        w_full;
wire        r_empty;
wire [7:0]  r_data;
parameter       W_CLK = 20;
parameter       R_CLK = 17;
initial begin
        r_clk = 0;
        w_clk = 0;       
end
//写初始化模块
initial begin
        w_en = 1'b0;
        w_data = 0;
        #300
        write_data(256);
end
//读的初始化模块
initial begin
        r_en = 1'b0;
        @(posedge w_full);
        #40;
        read_data(256);
end
always #(R_CLK/2)  r_clk = ~r_clk;
always #(W_CLK/2)  w_clk = ~w_clk;

fifo fifo_inst(
    .w_clk      (w_clk),
    .r_clk      (r_clk),
    .w_en       (w_en),
    .w_data     (w_data),
    .r_en       (r_en),
    .w_full     (w_full),
    .r_data     (r_data),
    .r_empty    (r_empty)
);

task read_data(len);
        integer i,len;
        begin
            for(i=0;i<len;i=i+1)
            begin
                @(posedge r_clk);
                r_en = 1'b1;
            end
            @(posedge r_clk);
            r_en = 1'b0;
        end
endtask

task write_data(len);
        integer i,len;
        begin
            for(i=0;i<len;i=i+1)
            begin
                @(posedge w_clk);
                w_en = 1'b1;
                w_data = i;
            end
            @(posedge w_clk);
            w_en = 1'b0;
            w_data = 0;
        end
endtask

endmodule

