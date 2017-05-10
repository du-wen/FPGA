module fifomen(
    input   wire        w_clk,
    input   wire        r_clk,
    input   wire        w_en,//������FIFO��д����ģ��
    input   wire        w_full,//������FIFO��д����ģ��
    input   wire  [7:0] w_data,//�������ⲿ����Դ
    input   wire  [2:0] w_addr,//������FIFO��д����ģ��
    input   wire        r_empty,//������FIFO�Ķ�����ģ��
    input   wire  [2:0] r_addr,//������FIFO�Ķ�����ģ��
    output  wire  [7:0] r_data//�������Ǵ��ڲ�ram�ж�ȡ
);

wire        ram_w_en;

assign      ram_w_en = w_en &(~w_full);
dp_ram dp_ram_inst(
       .w_clk        (w_clk),
       .r_clk        (r_clk),
       .w_en         (ram_w_en),
       .w_data       (w_data),
       .r_data       (r_data),
       .w_addr       (w_addr),
       .r_addr       (r_addr)     
);

endmodule