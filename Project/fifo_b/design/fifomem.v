module fifomen(
    input   wire        w_clk,
    input   wire        r_clk,
    input   wire        w_en,//来自于FIFO的写控制模块
    input   wire        w_full,//来自于FIFO的写控制模块
    input   wire  [7:0] w_data,//来自于外部数据源
    input   wire  [2:0] w_addr,//来自于FIFO的写控制模块
    input   wire        r_empty,//来自于FIFO的读控制模块
    input   wire  [2:0] r_addr,//来自于FIFO的读控制模块
    output  wire  [7:0] r_data//读数据是从内部ram中读取
);

wire        ram_w_en;

assign      ram_w_en = w_en &(~w_full);
dp_ram dp_ram_inst(
       .w_clk        (w_clk),
       .r_clk        (r_clk),
       .w_en         (ram_w_en),
       .w_data       (w_data),
       .r_data       (r_data),
       .w_addr       (w_addr),
       .r_addr       (r_addr)     
);

endmodule