module r_ctrl(
    input   wire        r_clk,//��ʱ��
    input   wire        rst_n,
    input   wire        r_en,//��ʹ��
    input   wire  [3:0] w_addr,//дʱ�����е�д��ַָ��
    output  reg         r_empty,//���ձ�־
    output  wire  [3:0] r_addr //����ַ������
);

reg    [3:0]    addr;
wire   [3:0]    addr_wire;
reg    [3:0]    w_addr_d1,w_addr_d2;
//�����Ľ���ʱ��ͬ��
always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        {w_addr_d2,w_addr_d1} <= 8'b0;
    else
        {w_addr_d2,w_addr_d1} <= {w_addr_d1,w_addr};

//�����ƵĶ���ַ
assign r_addr = addr;
always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        addr <= 4'd0;
    else
        addr <= addr_wire;

assign addr_wire = addr + ((~r_empty)&r_en);

//���ձ�־�Ĳ���

always @(posedge r_clk or negedge rst_n)
    if(rst_n == 1'b0)
        r_empty <= 1'b0;
    else if (addr_wire == w_addr_d2)  //���ݷ�����֤һ�´����ĶԿ�����־��Ӱ�죿����
    // else if (gaddr_wire == w_gaddr) //�����ģ�ֱ�Ӳ���w_gaddr
        r_empty <= 1'b1;
    else
        r_empty <= 1'b0;
endmodule