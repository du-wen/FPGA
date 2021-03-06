module spi_ctrl(
    input   wire            sclk,//50M
    input   wire            rst_n,
    input   wire            work_en,//触发配置操作的使能
    output  reg             conf_end,//配置完成标志
    output  wire            spi_clk,//50-60mhz
    output  wire            spi_sdi,
    output  wire            spi_csn,
    input   wire            spi_sdo//读输入管脚不进行编程
);

parameter       IDLE = 5'b0_0001;
parameter       WAIT = 5'b0_0010;
parameter       R_MEM= 5'b0_0100;
parameter       W_REG= 5'b0_1000;
parameter       STOP = 5'b1_0000;
 
parameter       H_DIV_CYC   =   5'd25-1;//分频,用于产生1M时钟

reg     [4:0]   state;//状态机的寄存器变量，编码方式采用独热码
reg     [4:0]   div_cnt;
reg             clk_p = 1'b0;
wire            clk_n;
reg             pose_flag;//用于标志上升沿
reg  [3:0]      wait_cnt;
reg  [3:0]      shift_cnt;
reg  [4:0]      r_addr;
wire [15:0]     r_data;
wire            wren;
reg  [15:0]     shift_buf;//移位寄存器，用于缓存ram输出的数据，在R_MEM状态下完成赋值
reg            data_end;
reg             sdi;//spi的输出寄存器
reg             csn;
reg             tck;//产生D触发器延时一拍，使时钟与输出数据sdi中心对其

//分频计数器
always @(posedge sclk or negedge rst_n)
begin
  if (rst_n == 1'b0)
    div_cnt <= 5'd0;
  else if(div_cnt == H_DIV_CYC)
    div_cnt <= 5'd0;
  else
    div_cnt <= div_cnt + 1'b1;
end
//分频时钟不允许做寄存器的触发时钟，也就是不能写在always的触发列表中(不准确)
always @(posedge sclk or negedge rst_n)
begin
  if(rst_n == 1'b0)
    clk_p <= 1'b0;
  else if(div_cnt == H_DIV_CYC)
    clk_p <= ~clk_p;
end

assign clk_n = ~clk_p;//反向是为了达到中心对其的目的

always @(posedge sclk or negedge rst_n)
begin
  if(rst_n == 1'b0)
    pose_flag <= 1'b0;
  else if(clk_p == 1'b0 && div_cnt == H_DIV_CYC)
    pose_flag <= 1'b1;         //clk_p出现上升沿的时候pose_flag拉高,pose_flag周期为1mhz持续时间为20ns的脉冲
  else  pose_flag <= 1'b0;
end

always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    wait_cnt <= 4'd0;
  else if (state == WAIT && pose_flag == 1'b1)
    wait_cnt <= wait_cnt + 1'b1;
  else if(state != WAIT)
    wait_cnt <= 4'd0;

//fsm，此处用两段式状态机
always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    state <= IDLE;
  else case(state)
    IDLE: if(work_en == 1'b1)
            state <= WAIT;
    WAIT: if(wait_cnt[3] == 1'b1)
            state <= R_MEM;
    R_MEM: state <= W_REG;
    W_REG:if((shift_cnt == 4'd15) && (pose_flag == 1'b1 )&& (data_end != 1'b1))
            state <= WAIT;
          else if((shift_cnt == 4'd15) && (pose_flag == 1'b1 )&& (data_end == 1'b1))
            state <= STOP;
    STOP: state <= STOP;
    default: state <= IDLE;
  endcase

always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    shift_cnt <= 4'd0;
  else if(state == W_REG && pose_flag == 1'b1)
    shift_cnt <= shift_cnt + 1'b1;
  else if(state != W_REG)
    shift_cnt <= 4'd0;

//读mem的地址的产生，在R_MEM时候经过D触发器赋值，在W_REG实现地址加1
always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    r_addr <=  4'd0;
  else if(state == R_MEM)
    r_addr <= r_addr + 1'b1;

//data_end最后一个需要移位数据
always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    data_end <= 5'd0;
  else if(state == R_MEM && (&r_addr) == 1'b1)//等效于state == R_MEM && r_addr == 5'd31
    data_end <= 1'b1;


assign wren = 1'b0;  

always @(posedge sclk or negedge rst_n)
   if(rst_n == 1'b0)
     shift_buf <= 16'd0;
   else if(state == R_MEM)
     shift_buf <= r_data;//R_MEM状态下，数据缓冲进来
   else if(state == W_REG && pose_flag == 1'b1)
     shift_buf <= {shift_buf[14:0],1'b1};//W_REG且pose_flag为1时，数据左移一位，移到sdi中去（相当于并转串）

//数据输出
always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    sdi <= 1'b0;
  else if(state == W_REG)//不用state == W_REG && pose_flag == 1'b1,与sclk同步，而不是与pose_flag同步，数据延后sclk，而不是pose_flag，使其最后一位数据尽量少处于STOP状态下
    sdi <= shift_buf[15];
  else if(state != W_REG)
    sdi <= 1'b0;
    
//cs的产生，与sdi类似
always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    csn <= 1'b1;//csn为0时是选通
  else if(state == W_REG)
    csn <= 1'b0;
  else 
    csn <= 1'b1;  

//产生于数据中心对其的时钟
always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    tck <= 1'b0;
  else if(state == W_REG)//state做标志用
    tck <= clk_n;
  else
    tck <= 1'b0;

assign spi_clk = tck;
assign spi_csn = csn;
assign spi_sdi = sdi;

always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    conf_end <= 1'b0;
  else if(state == STOP)
    conf_end <= 1'b1;
    
//把ram当rom用，我们不对其进行写操作，只是不断的从ram中读数据
ram_16_32_sr	ram_16_32_sr_inst (
	.address ( r_addr ),//读地址
	.clock ( sclk ),
	.data ( 16'd0 ),//写数据
	.wren ( wren ),//写使能高有效，读使能低有效
	.q ( r_data )//读数据
	);
    
//全部用sclk作为时钟，不用计数器产生的clk_p时钟，sclk是系统时钟，会布局到全局时钟网络，clk_p作为数据线，会产生很大的时钟偏斜（skew），会影响我们的建立时间跟保持时间。因此，我们用sclk作为同步时钟。 
endmodule