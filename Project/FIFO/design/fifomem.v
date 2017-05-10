module fifomen(
    input   wire        w_clk,
    input   wire        r_clk,
    input   wire        w_en,//������FIFO��д����ģ��
    input   wire        w_full,//������FIFO��д����ģ��
    input   wire  [7:0] w_data,//�������ⲿ����Դ
    input   wire  [8:0] w_addr,//������FIFO��д����ģ��
    input   wire        r_empty,//������FIFO�Ķ�����ģ��
    input   wire  [8:0] r_addr,//������FIFO�Ķ�����ģ��
    output  wire  [7:0] r_data//�������Ǵ��ڲ�ram�ж�ȡ
);

wire        ram_w_en;

assign      ram_w_en = w_en &(~w_full);
//ipcore�Ѿ���Ϊ216��ȵģ���������û�и�
dp_ram_512_8_swsr	dp_ram_512_8_swsr_inst (
    //д���ݽӿ�
	.wrclock ( w_clk ),
    .wren ( ram_w_en ),
    .wraddress ( w_addr[7:0] ),
    .data ( w_data ),	
    //�����ݽӿ�
	.rdclock ( r_clk ),
	.rdaddress ( r_addr[7:0] ),		
	.q ( r_data )
	);

endmodule