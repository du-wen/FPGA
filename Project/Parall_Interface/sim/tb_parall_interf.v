`timescale      1ns/1ns
module      tb_parall_interf();

parameter   setup_time = 2;
parameter   hold_time = 2;
parameter   data_time = 4;
parameter   read_wait = 5;//由于cs_n打了两拍，我们需要把read_wait时间延长，保证我们建立时间的时序

reg         sclk,rst_n;
reg         cs_n,rd_n,wr_n;
reg [15:0]  data;
reg [7:0]   addr;
tri [15:0]  w_data;     

initial begin
    sclk = 0;
    rst_n = 0;
    #200
    rst_n = 1;
end

initial begin
    cs_n = 1;
    rd_n = 1;
    wr_n = 1;
    data = 16'd0;
    addr = 8'd0;
    @(posedge rst_n)
    #100;
    write_data(8);
    #100
    read_data(8);
end

always #10 sclk = ~sclk;

parall_interf parall_interf_inst(
    .sclk           (sclk),//50Mhz
    .rst_n          (rst_n),
    .cs_n           (cs_n),
    .rd_n           (rd_n),
    .wr_n           (wr_n),
    .data           (w_data),//1M
    .addr           (addr)        
);
//测试激励的三态门
assign w_data = (wr_n==1'b0)?data:16'hzzzz;

//写数据的任务
task    write_data(len);
        integer i,len;
        begin
          for(i=0;i<len;i=i+1)
          begin
            cs_n = 0;
            data = i[15:0];//数据写入
            addr = i[7:0];
            setup_dly();
            wr_n = 0;
            data_dly();
            wr_n = 1; 
            hold_dly();
          end
          cs_n = 1;
        end
endtask

//读数据的task
task    read_data(len);
        integer i,len;
        begin
          for(i=0;i<len;i=i+1)
          begin
            cs_n = 0;
            addr = i[7:0];
            read_dly();
            rd_n = 0;
            data_dly();
            $display("read data addr is %d data is %d",i,w_data);
            rd_n = 1; 
          end
          cs_n = 1;
        end
endtask

//基本的延时任务
task    setup_dly();
        integer i;
        begin
          for(i=0;i<setup_time;i=i+1)
            begin
              @(posedge sclk);              
            end
        end
endtask

task    hold_dly();
        integer i;
        begin
          for(i=0;i<hold_time;i=i+1)
            begin
              @(posedge sclk);               
            end
        end
endtask

task    data_dly();
        integer i;
        begin
          for(i=0;i<data_time;i=i+1)
            begin
              @(posedge sclk);               
            end
        end
endtask

task    read_dly();
        integer i;
        begin
          for(i=0;i<read_wait;i=i+1)
            begin
              @(posedge sclk);               
            end
        end
endtask
endmodule