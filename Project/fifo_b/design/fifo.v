module fifo(
    input   wire        w_clk,
    input   wire        r_clk,
    input   wire        rst_n,
    input   wire        w_en,
    input   wire  [7:0] w_data,
    input   wire        r_en,
    output  wire        w_full,
    output  wire  [7:0] r_data,
    output  wire        r_empty
);

wire    [3:0]   w_addr;

wire    [3:0]   r_addr;

w_ctrl w_ctrl_inst(
        .w_clk      (w_clk),  //дʱ��
        .rst_n      (rst_n),  //��λ
        .w_en       (w_en),   //дʹ��
        .w_full     (w_full), //д����־
        .w_addr     (w_addr),  //256��ȵ�FIFOд�����Ƶ�ַ
        .r_addr     (r_addr)
);

fifomen fifomen_inst(
    .w_clk      (w_clk),
    .r_clk      (r_clk),
    .w_en       (w_en),//������FIFO��д����ģ��
    .w_full     (w_full),//������FIFO��д����ģ��
    .w_data     (w_data),//�������ⲿ����Դ
    .w_addr     (w_addr[2:0]),//������FIFO��д����ģ��
    .r_empty    (r_empty),//������FIFO�Ķ�����ģ��
    .r_addr     (r_addr[2:0]),//������FIFO�Ķ�����ģ��
    .r_data     (r_data)//�������Ǵ��ڲ�ram�ж�ȡ
);

r_ctrl r_ctrl_inst(
   .r_clk       (r_clk),//��ʱ��
   .rst_n       (rst_n),
   .r_en        (r_en),//��ʹ��
   .r_empty     (r_empty),//���ձ�־
   .r_addr      (r_addr), //����ַ������
   .w_addr     (w_addr)
);

endmodule
