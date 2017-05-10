module w_ctrl(
    input  wire         w_clk,  //写时钟
    input  wire         rst_n,  //复位
    input  wire         w_en,   //写使能
    input  wire [8:0]   r_gaddr,//读时钟过来的格雷码读地址指针
    output reg         w_full, //写满标志
    output wire [8:0]   w_addr, //256深度的FIFO写二进制地址
    output wire [8:0]   w_gaddr //写FIFO地址格雷码编码
);

reg     [8:0]   addr;
reg     [8:0]   gaddr;
wire    [8:0]   addr_wire;
wire    [8:0]   gaddr_wire;
reg     [8:0]   r_gaddr_d1,r_gaddr_d2;
//对读时钟过来的格雷码读地址指针进行打两拍，使其同步到写时钟域
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        {r_gaddr_d2,r_gaddr_d1} <= 18'b0;
    else
        {r_gaddr_d2,r_gaddr_d1} <= {r_gaddr_d1,r_gaddr};
assign w_gaddr = gaddr;
//产生写ram的地址指针，二进制的(格雷码计数器)
assign w_addr = addr;
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        addr <= 9'b0;
    else
        addr <= addr_wire;
        
assign addr_wire = addr + ((~w_full)&w_en);
//转换格雷码地址
assign gaddr_wire = (addr_wire>>1)^addr_wire;
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        gaddr <= 9'b0;
    else
        gaddr <= gaddr_wire;
assign w_gaddr = gaddr;
//写满标志产生完成        
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        w_full <= 1'b0;
    else if({~gaddr_wire[8:7],gaddr_wire[6:0]}==r_gaddr_d2)
        w_full <= 1'b1;
    else
        w_full <= 1'b0;
        
endmodule