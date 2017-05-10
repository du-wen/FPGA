module parall_interf(
    input wire          sclk,//50Mhz
    input wire          rst_n,
    input wire          cs_n,
    input wire          rd_n,
    input wire          wr_n,
    inout tri  [15:0]   data,//tri表示三态，写成wire也可以，不能接reg变量，此设计中，这是一个半双工的异步接口
    input wire [7:0]    addr        
);

reg [15:0]  data_0,data_1,data_2,data_3,data_4,data_5,data_6,data_7;//也可以写成reg [15:0] data[7:0],memory形式
reg [2:0]   cs_n_r,rd_n_r,wr_n_r;
reg [47:0]  data_r;
reg [23:0]  addr_r; 
reg [15:0]  r_data; 

//降低亚稳态，把cs_n,rd_n,wr_n;单比特信号打两拍;addr和data也打两拍
//系统时钟远远大于data时钟时，可以不进行打拍

always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    {cs_n_r,rd_n_r,wr_n_r} <= 9'h1ff;//低有效
  else 
    {cs_n_r,rd_n_r,wr_n_r} <= {{cs_n_r[1:0],cs_n},{rd_n_r[1:0],rd_n},{wr_n_r[1:0],wr_n}};//将cs_n,rd_n,wr_n移入相应位  

always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)begin
    data_r <= 48'd0;
    addr_r <= 24'd0;
  end
  else begin
    data_r <= {data_r[31:0],data};//第一拍{data_r[31:0],data_d1},第二拍为{data_r[15:0],data_d1,data_d2}
    addr_r <= {addr_r[15:0],addr};
  end  

//写数据
always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0) begin
    data_0 <= 8'd0;
    data_1 <= 8'd0;
    data_2 <= 8'd0;
    data_3 <= 8'd0;
    data_4 <= 8'd0;
    data_5 <= 8'd0;
    data_6 <= 8'd0;
    data_7 <= 8'd0;
  end
  else if(cs_n_r[2] == 1'b0 && rd_n_r[2] == 1'b1 && wr_n_r[2] == 1'b0)begin
    case(addr_r[23:16])
      8'd0:data_0 <= data_r[47:32];
      8'd1:data_1 <= data_r[47:32];
      8'd2:data_2 <= data_r[47:32];
      8'd3:data_3 <= data_r[47:32];
      8'd4:data_4 <= data_r[47:32];
      8'd5:data_5 <= data_r[47:32];
      8'd6:data_6 <= data_r[47:32];
      8'd7:data_7 <= data_r[47:32];
      default:begin    //或者直接default ;
        data_0 <= data_0;
        data_1 <= data_1;
        data_2 <= data_2;
        data_3 <= data_3;
        data_4 <= data_4;
        data_5 <= data_5;
        data_6 <= data_6;
        data_7 <= data_7;
        end
    endcase
  end

//读数据
always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    r_data <= 8'd0;
  else if(cs_n_r[2] == 1'b0 && wr_n_r[2] == 1'b1)begin  //cs_n拉低，写使能为高的时候，就把r_data输出了，不用等到读使能拉低
    case(addr_r[23:16])
      8'd0:r_data <= data_0;
      8'd1:r_data <= data_1;
      8'd2:r_data <= data_2;
      8'd3:r_data <= data_3;
      8'd4:r_data <= data_4;
      8'd5:r_data <= data_5;
      8'd6:r_data <= data_6;
      8'd7:r_data <= data_7;
      default:r_data <= 16'd0;
    endcase  
  end  

//三态门
assign data = (cs_n_r[2] == 1'b0 && rd_n_r[2] == 1'b0)?r_data:16'hzzzz;//使能为低，读使能为低的时候，data接受FPGA中的数据，此时data为输出状态，把r_data输出，否则为高阻态，实际上中间的判断条件就是三态门的使能控制条件，参考documents中的FPGA三态门的图片
  
endmodule