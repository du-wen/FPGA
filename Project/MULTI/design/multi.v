module multi(
    input wire          sclk,
    input wire          rst_n,
    input wire  [15:0]  in_a,
    input wire  [15:0]  in_b,
    output wire [31:0]  out_rlst    
);
//乘法器
// multi_16_16_l1	multi_16_16_l1_inst (
	// .clock ( sclk ),
	// .dataa ( in_a ),
	// .datab ( in_b ),
	// .result ( out_rlst )
	// );
//除法器
divider_16d8_l3	divider_16d8_l3_inst (
	.clock ( sclk ),
	.denom ( in_b[7:0] ),//除数
	.numer ( in_a ),//被除数
	.quotient ( out_rlst[15:0] ),
	.remain ( remain_sig )
	);
    
endmodule 