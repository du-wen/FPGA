`timescale      1ns/1ns

module tb_dp_ram;
reg          w_en;
reg          w_clk;
reg          r_clk;
reg  [3:0]   w_addr;
reg  [3:0]   r_addr;
reg  [7:0]   w_data;
wire [7:0]   r_data; 

//wire [63:0]  data;

parameter CLK = 20;
initial begin
    w_clk = 0;
    r_clk = 0;
end

initial begin 
    w_en = 0;
    w_addr = 0;
    w_data = 0;
    #100
    write_data(7);
end

initial begin
    r_addr = 0;
    #500
    read_data(7);
end

always #(CLK/2) w_clk = ~ w_clk;
always #(CLK/2) r_clk = ~ r_clk;

dp_ram dp_ram_inst(
       .w_clk        (w_clk),
       .r_clk        (r_clk),
       .w_en         (w_en),
       .w_data       (w_data),
       .r_data       (r_data),
       .w_addr       (w_addr),
       .r_addr       (r_addr)     
);

task write_data(len);
    integer i,len;
    begin
        for(i=0;i<len;i=i+1)
        begin
            @(posedge w_clk)
            w_en = 1;
            w_addr = w_addr + 1;
            w_data = w_addr;
        end
        @(posedge w_clk)
        w_en = 0;
        w_addr = 0;
        w_data = 0;
    end
endtask

task read_data(len);
    integer i,len;
    begin
        for(i=0;i<len;i=i+1)
        begin
            @(posedge r_clk)
            r_addr = r_addr + 1;
        end
        @(posedge r_clk)
        r_addr = 0;
    end
endtask

endmodule