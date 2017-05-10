module fifo(
    input           w_clk,
    input           r_clk,
    input           w_en,
    input           r_en,
    input   [7:0]   w_data,
    output  [7:0]   r_data,
    output          w_full,
    output          r_empty
);


fifo_256_8	fifo_256_8_inst (
	.data     ( w_data ),
	.rdclk    ( r_clk ),
	.rdreq    ( r_en ),
	.wrclk    ( w_clk ),
	.wrreq    ( w_en ),
	.q        ( r_data ),
	.rdempty  ( r_empty ),
	.wrfull   ( w_full )
	);
endmodule
