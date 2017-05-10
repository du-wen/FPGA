module r_ctrl(
    input   wire        r_clk,//��ʱ��
    input   wire        rst_n,
    input   wire        r_en,//��ʹ��
    input   wire  [8:0] w_gaddr,//дʱ�����е�д��ַָ��
    output  reg         r_empty,//���ձ�־
    output  wire  [8:0] r_addr,//����ַ������
    output  wire  [8:0] r_gaddr//���������ַ
);

reg    [8:0]    addr;
reg    [8:0]    gaddr;
wire   [8:0]    addr_wire;
wire   [8:0]    gaddr_wire;
reg    [8:0]    w_gaddr_d1,w_gaddr_d2;
//�����Ľ���ʱ��ͬ��
always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        {w_gaddr_d2,w_gaddr_d1} <= 18'b0;
    else
        {w_gaddr_d2,w_gaddr_d1} <= {w_gaddr_d1,w_gaddr};

//�����ƵĶ���ַ
assign r_addr = addr;
always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        addr <= 9'd0;
    else
        addr <= addr_wire;

assign addr_wire = addr + ((~r_empty)&r_en);
//������Ķ���ַ
assign r_gaddr = gaddr;
assign gaddr_wire = (addr_wire>>1)^addr_wire;

always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        gaddr <= 9'd0;
    else 
        gaddr <= gaddr_wire;

//���ձ�־�Ĳ���

always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        r_empty <= 1'b0;
    else if (gaddr_wire == w_gaddr_d2)  //���ݷ�����֤һ�´����ĶԿ�����־��Ӱ�죿����
        r_empty <= 1'b1;
    else
        r_empty <= 1'b0;
endmodule