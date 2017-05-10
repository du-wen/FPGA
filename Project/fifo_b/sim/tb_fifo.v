`timescale      1ns/1ns

module  tb_fifo;
reg         r_clk,w_clk,rst_n;
reg         w_en;
wire  [7:0]  w_data;
reg         r_en;
wire        w_full;
wire        r_empty;
wire [7:0]  r_data;
parameter       CLK_W = 12;
parameter       CLK_R = 11;

reg [7:0] counter = 8'h00;

always @ (posedge w_clk or negedge rst_n)
begin
	if(~rst_n) 
		counter <= 8'h00;
	else 
		if(~w_full)
			counter <= counter + 1'b1;
		else 
			counter <= counter;
end

reg [7:0] counter_check = 8'h00;
always @ (posedge r_clk or negedge rst_n)
begin
	if(~rst_n) 
		counter_check <= 8'h00;
	else 
		if(~r_empty)
			counter_check <= counter_check + 1'b1;
		else 
			counter_check <= counter_check;
end

assign w_data = counter;
assign error  = (r_data == counter_check) ? 1'b0 : 1'b1;

initial begin
        w_en  = 0;
        r_en  = 0;
        r_clk = 0;
        w_clk = 0;
        rst_n = 0;
        #200
        rst_n = 1;
        w_en  = 1;
        r_en  = 1;
end
// 写初始化模块
// initial begin
        // w_en = 1'b0;
        // w_data = 0;
        // #300
        // write_data(8);
// end
// 读的初始化模块
// initial begin
        // r_en = 1'b0;
        // @(posedge w_full);
        // #40;
        // read_data(8);
// end
// initial begin
        // r_en = 1'b0;
        // #350
        // read_data(8);
// end
always #(CLK_W/2)  w_clk = ~w_clk;
always #(CLK_R/2)  r_clk = ~r_clk;


fifo fifo_inst(
    .w_clk      (w_clk),
    .r_clk      (r_clk),
    .rst_n      (rst_n),
    .w_en       (w_en),
    .w_data     (w_data),
    .r_en       (r_en),
    .w_full     (w_full),
    .r_data     (r_data),
    .r_empty    (r_empty)
);

// task read_data(len);
        // integer i,len;
        // begin
            // for(i=0;i<len;i=i+1)
            // begin
                // @(posedge r_clk);
                // r_en = 1'b1;
            // end
            // @(posedge r_clk);
            // r_en = 1'b0;
        // end
// endtask

// task write_data(len);
        // integer i,len;
        // begin
            // for(i=0;i<len;i=i+1)
            // begin
                // @(posedge w_clk);
                // w_en = 1'b1;
                // w_data = i;
            // end
            // @(posedge w_clk);
            // w_en = 1'b0;
            // w_data = 0;
        // end
// endtask

endmodule

