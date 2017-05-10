`timescale      1ns/1ns

module tb_RAM;
reg          w_clk;
reg  [3:0]   w_addr;
reg  [7:0]   din; 
wire [63:0]  data;

parameter CLK = 20;
initial begin
    w_clk = 0;
end

initial begin 
    w_addr = 0;
    din = 0;
    #100
    write_data(8);
end

always #(CLK/2) w_clk = ~ w_clk;

RAM RAM_inst(
        .w_clk       (w_clk),
        .din         (din),
        .w_addr      (w_addr),
        .data        (data)
);
task write_data(len);
    integer i,len;
    begin
        for(i=0;i<len;i=i+1)
        begin
            @(posedge w_clk)
            w_addr = w_addr + 1;
            din = w_addr;
        end
        @(posedge w_clk)
        w_addr = 0;
        din = 0;
    end
endtask

endmodule