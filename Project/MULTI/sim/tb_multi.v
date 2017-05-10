`timescale      1ns/1ns
module  tb_multi;

reg           sclk,rst_n;
reg  [15:0]   in_d;
wire [31:0]   rslt;

initial begin
        rst_n = 1'b0;
        sclk = 1'b0;
        #100
        gen_data();
end

always #10 sclk = ~sclk;

multi multi_inst(
    .sclk       (sclk),
    .rst_n      (rst_n),
    .in_a       (in_d),
    .in_b       (in_d),
    .out_rlst   (rslt)    
);

task    gen_data();
        integer i;
        begin
            for(i=0;i<255;i=i+1)
            begin
                @(posedge sclk)
                in_d <= {$random} % 32768;
            end
        end

endtask

endmodule