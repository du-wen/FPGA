module r_ctrl(
    input   wire        r_clk,//读时钟
    input   wire        rst_n,
    input   wire        r_en,//读使能
    input   wire  [8:0] w_gaddr,//写时钟域中的写地址指针
    output  reg         r_empty,//读空标志
    output  wire  [8:0] r_addr,//读地址二进制
    output  wire  [8:0] r_gaddr//读格雷码地址
);

reg    [8:0]    addr;
reg    [8:0]    gaddr;
wire   [8:0]    addr_wire;
wire   [8:0]    gaddr_wire;
reg    [8:0]    w_gaddr_d1,w_gaddr_d2;
//打两拍进行时钟同步
always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        {w_gaddr_d2,w_gaddr_d1} <= 18'b0;
    else
        {w_gaddr_d2,w_gaddr_d1} <= {w_gaddr_d1,w_gaddr};

//二进制的读地址
assign r_addr = addr;
always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        addr <= 9'd0;
    else
        addr <= addr_wire;

assign addr_wire = addr + ((~r_empty)&r_en);
//格雷码的读地址
assign r_gaddr = gaddr;
assign gaddr_wire = (addr_wire>>1)^addr_wire;

always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        gaddr <= 9'd0;
    else 
        gaddr <= gaddr_wire;

//读空标志的产生

always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        r_empty <= 1'b0;
    else if (gaddr_wire == w_gaddr_d2)  //根据仿真验证一下打两拍对空满标志的影响？？？
        r_empty <= 1'b1;
    else
        r_empty <= 1'b0;
endmodule