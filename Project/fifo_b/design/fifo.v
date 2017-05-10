module fifo(
    input   wire        w_clk,
    input   wire        r_clk,
    input   wire        rst_n,
    input   wire        w_en,
    input   wire  [7:0] w_data,
    input   wire        r_en,
    output  wire        w_full,
    output  wire  [7:0] r_data,
    output  wire        r_empty
);

wire    [3:0]   w_addr;

wire    [3:0]   r_addr;

w_ctrl w_ctrl_inst(
        .w_clk      (w_clk),  //写时钟
        .rst_n      (rst_n),  //复位
        .w_en       (w_en),   //写使能
        .w_full     (w_full), //写满标志
        .w_addr     (w_addr),  //256深度的FIFO写二进制地址
        .r_addr     (r_addr)
);

fifomen fifomen_inst(
    .w_clk      (w_clk),
    .r_clk      (r_clk),
    .w_en       (w_en),//来自于FIFO的写控制模块
    .w_full     (w_full),//来自于FIFO的写控制模块
    .w_data     (w_data),//来自于外部数据源
    .w_addr     (w_addr[2:0]),//来自于FIFO的写控制模块
    .r_empty    (r_empty),//来自于FIFO的读控制模块
    .r_addr     (r_addr[2:0]),//来自于FIFO的读控制模块
    .r_data     (r_data)//读数据是从内部ram中读取
);

r_ctrl r_ctrl_inst(
   .r_clk       (r_clk),//读时钟
   .rst_n       (rst_n),
   .r_en        (r_en),//读使能
   .r_empty     (r_empty),//读空标志
   .r_addr      (r_addr), //读地址二进制
   .w_addr     (w_addr)
);

endmodule
