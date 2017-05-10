module w_ctrl(
    input  wire         w_clk,  //дʱ��
    input  wire         rst_n,  //��λ
    input  wire         w_en,   //дʹ��
    input  wire [3:0]   r_gaddr,//��ʱ�ӹ����ĸ��������ַָ��
    output reg          w_full, //д����־
    output wire [3:0]   w_addr, //256��ȵ�FIFOд�����Ƶ�ַ
    output wire [3:0]   w_gaddr //дFIFO��ַ���������
);

reg     [3:0]   addr;
reg     [3:0]   gaddr;
wire    [3:0]   addr_wire;
wire    [3:0]   gaddr_wire;
reg     [3:0]   r_gaddr_d1,r_gaddr_d2;
//�Զ�ʱ�ӹ����ĸ��������ַָ����д����ģ�ʹ��ͬ����дʱ����
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        {r_gaddr_d2,r_gaddr_d1} <= 8'b0;
    else
        {r_gaddr_d2,r_gaddr_d1} <= {r_gaddr_d1,r_gaddr};
assign w_gaddr = gaddr;
//����дram�ĵ�ַָ�룬�����Ƶ�(�����������)
assign w_addr = addr;
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        addr <= 4'b0;
    else
        addr <= addr_wire;
        
assign addr_wire = addr + ((~w_full)&w_en);
//ת���������ַ
assign gaddr_wire = (addr_wire>>1)^addr_wire;
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        gaddr <= 4'b0;
    else
        gaddr <= gaddr_wire;
assign w_gaddr = gaddr;
//д����־�������        
always @(posedge w_clk or negedge rst_n)
    if(rst_n == 1'b0)
        w_full <= 1'b0;
    else if({~gaddr_wire[3:2],gaddr_wire[1:0]}==r_gaddr_d2)//�����ĵĵ�ַ
    // else if({~gaddr_wire[3:2],gaddr_wire[1:0]}==r_gaddr)//�����ĵĵ�ַ
        w_full <= 1'b1;
    else
        w_full <= 1'b0;
        
endmodule