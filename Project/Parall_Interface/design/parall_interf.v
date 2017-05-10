module parall_interf(
    input wire          sclk,//50Mhz
    input wire          rst_n,
    input wire          cs_n,
    input wire          rd_n,
    input wire          wr_n,
    inout tri  [15:0]   data,//tri��ʾ��̬��д��wireҲ���ԣ����ܽ�reg������������У�����һ����˫�����첽�ӿ�
    input wire [7:0]    addr        
);

reg [15:0]  data_0,data_1,data_2,data_3,data_4,data_5,data_6,data_7;//Ҳ����д��reg [15:0] data[7:0],memory��ʽ
reg [2:0]   cs_n_r,rd_n_r,wr_n_r;
reg [47:0]  data_r;
reg [23:0]  addr_r; 
reg [15:0]  r_data; 

//��������̬����cs_n,rd_n,wr_n;�������źŴ�����;addr��dataҲ������
//ϵͳʱ��ԶԶ����dataʱ��ʱ�����Բ����д���

always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    {cs_n_r,rd_n_r,wr_n_r} <= 9'h1ff;//����Ч
  else 
    {cs_n_r,rd_n_r,wr_n_r} <= {{cs_n_r[1:0],cs_n},{rd_n_r[1:0],rd_n},{wr_n_r[1:0],wr_n}};//��cs_n,rd_n,wr_n������Ӧλ  

always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)begin
    data_r <= 48'd0;
    addr_r <= 24'd0;
  end
  else begin
    data_r <= {data_r[31:0],data};//��һ��{data_r[31:0],data_d1},�ڶ���Ϊ{data_r[15:0],data_d1,data_d2}
    addr_r <= {addr_r[15:0],addr};
  end  

//д����
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
      default:begin    //����ֱ��default ;
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

//������
always @(posedge sclk or negedge rst_n)
  if(rst_n == 1'b0)
    r_data <= 8'd0;
  else if(cs_n_r[2] == 1'b0 && wr_n_r[2] == 1'b1)begin  //cs_n���ͣ�дʹ��Ϊ�ߵ�ʱ�򣬾Ͱ�r_data����ˣ����õȵ���ʹ������
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

//��̬��
assign data = (cs_n_r[2] == 1'b0 && rd_n_r[2] == 1'b0)?r_data:16'hzzzz;//ʹ��Ϊ�ͣ���ʹ��Ϊ�͵�ʱ��data����FPGA�е����ݣ���ʱdataΪ���״̬����r_data���������Ϊ����̬��ʵ�����м���ж�����������̬�ŵ�ʹ�ܿ����������ο�documents�е�FPGA��̬�ŵ�ͼƬ
  
endmodule