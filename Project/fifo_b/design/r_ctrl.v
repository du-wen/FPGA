module r_ctrl(
    input   wire        r_clk,//读时钟
    input   wire        rst_n,
    input   wire        r_en,//读使能
    input   wire  [3:0] w_addr,//写时钟域中的写地址指针
    output  reg         r_empty,//读空标志
    output  wire  [3:0] r_addr //读地址二进制
);

reg    [3:0]    addr;
wire   [3:0]    addr_wire;
reg    [3:0]    w_addr_d1,w_addr_d2;
//打两拍进行时钟同步
always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        {w_addr_d2,w_addr_d1} <= 8'b0;
    else
        {w_addr_d2,w_addr_d1} <= {w_addr_d1,w_addr};

//二进制的读地址
assign r_addr = addr;
always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        addr <= 4'd0;
    else
        addr <= addr_wire;

assign addr_wire = addr + ((~r_empty)&r_en);

//读空标志的产生

always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        r_empty <= 1'b0;
    else if (addr_wire == w_addr_d2)  //根据仿真验证一下打两拍对空满标志的影响？？？
    // else if (gaddr_wire == w_gaddr) //不打拍，直接采用w_gaddr
        r_empty <= 1'b1;
    else
        r_empty <= 1'b0;
endmodule