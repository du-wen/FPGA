module dp_ram(
input wire              w_clk,
input wire              r_clk,
input wire              w_en,
input wire       [7:0]  w_data,
output reg       [7:0]  r_data,
input wire       [3:0]  w_addr,
input wire       [3:0]  r_addr
);

reg 	  [7:0]  en;
reg       [7:0]  r_en;
reg       [63:0] data;
reg       [63:0] data1;
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

generate
genvar i;
for(i=0;i<8;i=i+1)
begin:write_data
always @(posedge w_clk)
  if(w_en)
    begin
      if(en[i])
        data[(8*i+7):(8*i)] <= w_data[7:0];
      else
        data[(8*i+7):(8*i)] <= data[(8*i+7):(8*i)];
    end
  else
    data <= data;
end
endgenerate

always @(posedge r_clk)
begin
	data1 <= data;
end
//assign  data1 = data;


always @(r_addr[2:0])
begin
  case(r_addr[2:0])
      3'b000: begin 
      r_en[0] = 1'b1; r_en[1] = 1'b0; r_en[2] = 1'b0; r_en[3] = 1'b0; r_en[4] = 1'b0; r_en[5] = 1'b0; r_en[6] = 1'b0; r_en[7] = 1'b0;
      end
      3'b001: begin 
      r_en[0] = 1'b0; r_en[1] = 1'b1; r_en[2] = 1'b0; r_en[3] = 1'b0; r_en[4] = 1'b0; r_en[5] = 1'b0; r_en[6] = 1'b0; r_en[7] = 1'b0;
      end
      3'b010: begin 
      r_en[0] = 1'b0; r_en[1] = 1'b0; r_en[2] = 1'b1; r_en[3] = 1'b0; r_en[4] = 1'b0; r_en[5] = 1'b0; r_en[6] = 1'b0; r_en[7] = 1'b0;
      end
      3'b011: begin 
      r_en[0] = 1'b0; r_en[1] = 1'b0; r_en[2] = 1'b0; r_en[3] = 1'b1; r_en[4] = 1'b0; r_en[5] = 1'b0; r_en[6] = 1'b0; r_en[7] = 1'b0;
      end
      3'b100: begin 
      r_en[0] = 1'b0; r_en[1] = 1'b0; r_en[2] = 1'b0; r_en[3] = 1'b0; r_en[4] = 1'b1; r_en[5] = 1'b0; r_en[6] = 1'b0; r_en[7] = 1'b0;
      end
      3'b101: begin 
      r_en[0] = 1'b0; r_en[1] = 1'b0; r_en[2] = 1'b0; r_en[3] = 1'b0; r_en[4] = 1'b0; r_en[5] = 1'b1; r_en[6] = 1'b0; r_en[7] = 1'b0;
      end
      3'b110: begin 
      r_en[0] = 1'b0; r_en[1] = 1'b0; r_en[2] = 1'b0; r_en[3] = 1'b0; r_en[4] = 1'b0; r_en[5] = 1'b0; r_en[6] = 1'b1; r_en[7] = 1'b0;
      end
      3'b111: begin 
      r_en[0] = 1'b0; r_en[1] = 1'b0; r_en[2] = 1'b0; r_en[3] = 1'b0; r_en[4] = 1'b0; r_en[5] = 1'b0; r_en[6] = 1'b0; r_en[7] = 1'b1;
      end   
  endcase
end
always @(posedge r_clk)
begin
  case(r_en)    
       8'b0000_0001:r_data <= data1[7:0];
	   8'b0000_0010:r_data <= data1[15:8];
	   8'b0000_0100:r_data <= data1[23:16];
	   8'b0000_1000:r_data <= data1[31:24];
	   8'b0001_0000:r_data <= data1[39:32];
	   8'b0010_0000:r_data <= data1[47:40];
	   8'b0100_0000:r_data <= data1[55:48];
	   8'b1000_0000:r_data <= data1[63:56];
	   default:r_data <= 8'b0000_0000;
  endcase
end
		

endmodule