module RAM(
input wire              w_clk,
//input wire            r_clk,
//input wire				  rst_n,
input wire       [7:0]  din,
//output wire      [7:0] dout,
//input wire            w_en,
//input wire      [7:0] w_data,
//output wire     [7:0] r_data,
input wire       [3:0]  w_addr,
//input wire      [3:0] r_addr
output reg       [63:0] data
);
reg 	  [7:0]  en;
//reg     [63:0] data;
//reg     [2:0]  addr;
always @(w_addr[2:0])
begin
  case(w_addr[2:0])
      3'b000: begin 
      en[0] = 1'b1; en[1] = 1'b0; en[2] = 1'b0; en[3] = 1'b0; en[4] = 1'b0; en[5] = 1'b0; en[6] = 1'b0; en[7] = 1'b0;
      end
      3'b001: begin 
      en[0] = 1'b0; en[1] = 1'b1; en[2] = 1'b0; en[3] = 1'b0; en[4] = 1'b0; en[5] = 1'b0; en[6] = 1'b0; en[7] = 1'b0;
      end
      3'b010: begin 
      en[0] = 1'b0; en[1] = 1'b0; en[2] = 1'b1; en[3] = 1'b0; en[4] = 1'b0; en[5] = 1'b0; en[6] = 1'b0; en[7] = 1'b0;
      end
      3'b011: begin 
      en[0] = 1'b0; en[1] = 1'b0; en[2] = 1'b0; en[3] = 1'b1; en[4] = 1'b0; en[5] = 1'b0; en[6] = 1'b0; en[7] = 1'b0;
      end
      3'b100: begin 
      en[0] = 1'b0; en[1] = 1'b0; en[2] = 1'b0; en[3] = 1'b0; en[4] = 1'b1; en[5] = 1'b0; en[6] = 1'b0; en[7] = 1'b0;
      end
      3'b101: begin 
      en[0] = 1'b0; en[1] = 1'b0; en[2] = 1'b0; en[3] = 1'b0; en[4] = 1'b0; en[5] = 1'b1; en[6] = 1'b0; en[7] = 1'b0;
      end
      3'b110: begin 
      en[0] = 1'b0; en[1] = 1'b0; en[2] = 1'b0; en[3] = 1'b0; en[4] = 1'b0; en[5] = 1'b0; en[6] = 1'b1; en[7] = 1'b0;
      end
      3'b111: begin 
      en[0] = 1'b0; en[1] = 1'b0; en[2] = 1'b0; en[3] = 1'b0; en[4] = 1'b0; en[5] = 1'b0; en[6] = 1'b0; en[7] = 1'b1;
      end   
  endcase
end
//always @(posedge w_clk or negedge rst_n)
//begin
//  if(rst_n == 1'b0)
//    addr <= 4'b0;	 
//  else
//    addr <= addr + 1;
//end
generate
genvar i;
for(i=0;i<8;i=i+1)
begin:data_processing
always @(posedge w_clk)
  begin
    if(en[i])
      data[(8*i+7):(8*i)] <= din[7:0];
    else
      data[(8*i+7):(8*i)] <= data[(8*i+7):(8*i)];
  end
end
endgenerate
endmodule