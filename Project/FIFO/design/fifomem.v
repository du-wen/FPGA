module fifomen(
    input   wire        w_clk,
    input   wire        r_clk,
    input   wire        w_en,//来自于FIFO的写控制模块
    input   wire        w_full,//来自于FIFO的写控制模块
    input   wire  [7:0] w_data,//来自于外部数据源
    input   wire  [8:0] w_addr,//来自于FIFO的写控制模块
    input   wire        r_empty,//来自于FIFO的读控制模块
    input   wire  [8:0] r_addr,//来自于FIFO的读控制模块
    output  wire  [7:0] r_data//读数据是从内部ram中读取
);

wire        ram_w_en;

assign      ram_w_en = w_en &(~w_full);
//ipcore已经改为216深度的，但是名字没有改
dp_ram_512_8_swsr	dp_ram_512_8_swsr_inst (
    //写数据接口
	.wrclock ( w_clk ),
    .wren ( ram_w_en ),
    .wraddress ( w_addr[7:0] ),
    .data ( w_data ),	
    //读数据接口
	.rdclock ( r_clk ),
	.rdaddress ( r_addr[7:0] ),		
	.q ( r_data )
	);

endmodule