`timescale          1ns/1ns

module tb_spi;
reg         sclk,rst_n;
reg         work_en;
wire        spi_clk,spi_csn,spi_sdi;
reg  [15:0] send_mem[31:0];
reg  [15:0] shift_buf;

initial begin
        rst_n = 0;
        sclk = 0;
        #100;
        rst_n = 1;
end

initial begin
        work_en = 0;
        #150;
        work_en = 1;
end

initial begin
        $readmemb("dac_ini_16_32.mif",send_mem);  //将dac_ini_16_32.mif文件中的数据读到send_mem中
end

always #10 sclk = ~ sclk;

initial begin
        rec_spi();
end

spi_ctrl spi_ctrl_inst(
   .sclk            (sclk),//50M
   .rst_n           (rst_n),
   .work_en         (work_en),//触发配置操作的使能
   .conf_end        (conf_end),//配置完成标志
   .spi_clk         (spi_clk),//50-60mhz
   .spi_sdi         (spi_sdi),
   .spi_csn         (spi_csn),
   .spi_sdo         ()//读输入管脚不进行编程
);

task rec_spi();
        integer i,j;
        begin
            for(i=0;i<32;i=i+1)begin
              for(j=0;j<16;j=j+1)begin
                @(posedge spi_clk);
                  shift_buf = {shift_buf[14:0],spi_sdi};//数据读入
                if(j==15 && shift_buf == send_mem[i])
                  $display("ok data index is %d rec_d=%d send_d=%d",i,shift_buf,send_mem[i]);//display相当于printf，在窗口中打印我们想要的信息                  
                else if(j == 15)
                  $display("error");
              end
            end
        end
endtask

endmodule