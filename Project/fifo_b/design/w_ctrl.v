module w_ctrl(
    input  wire         w_clk,  //写时钟
    input  wire         rst_n,  //复位
    input  wire         w_en,   //写使能
    input  wire [3:0]   r_addr,//读时钟过来的读地址指针
    output reg          w_full, //写满标志
    output wire [3:0]   w_addr //256深度的FIFO写二进制地址
);

reg     [3:0]   addr;
wire    [3:0]   addr_wire;
reg     [3:0]   r_addr_d1,r_addr_d2;
//对读时钟过来的格雷码读地址指针进行打两拍，使其同步到写时钟域
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        {r_addr_d2,r_addr_d1} <= 8'b0;
    else
        {r_addr_d2,r_addr_d1} <= {r_addr_d1,r_addr};
//产生写ram的地址指针，二进制的(格雷码计数器)
assign w_addr = addr;
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        addr <= 4'b0;
    else
        addr <= addr_wire;
        
assign addr_wire = addr + ((~w_full)&w_en);

//写满标志产生完成        
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        w_full <= 1'b0;
    else if({addr_wire[3],addr_wire[2:0]}==r_addr_d2)//打两拍的地址
    // else if({~gaddr_wire[3:2],gaddr_wire[1:0]}==r_gaddr)//不打拍的地址
        w_full <= 1'b1;
    else
        w_full <= 1'b0;
        
endmodule