module convlayer1(rst,en,in,out1,out2,out3,out4);
parameter SHIFT = 7;


input rst,en;
reg signed [4:0] [7:0] filter1,filter2,filter3,filter4;
input signed [4:0] [7:0] in;
wire signed [18:0] quant1,quant2,quant3,quant4;

reg signed [18:0] out_cu1,out_cu2,out_cu3,out_cu4;

output reg signed [7:0] out1,out2,out3,out4;
reg signed [7:0] bias1,bias2,bias3,bias4;


initial begin
	// Initialize filter values using concatenation
	filter1 = '{106, -86, 27, 69, 68};
	filter2 = '{20, 66, 67, 113, -106};
	filter3 = '{28, -9, -13, 64, 71};
	filter4 = '{103, 19, 49, -26, -127};
	
end

conv cu1(rst,en,in[0],in[1],in[2],in[3],in[4],filter1[0],filter1[1],filter1[2],filter1[3],filter1[4],quant1);
conv cu2(rst,en,in[0],in[1],in[2],in[3],in[4],filter2[0],filter2[1],filter2[2],filter2[3],filter2[4],quant2);
conv cu3(rst,en,in[0],in[1],in[2],in[3],in[4],filter3[0],filter3[1],filter3[2],filter3[3],filter3[4],quant3);
conv cu4(rst,en,in[0],in[1],in[2],in[3],in[4],filter4[0],filter4[1],filter4[2],filter4[3],filter4[4],quant4);

always@(*) begin
	/*
	out_cu1=(quant1+94)>>>SHIFT;
	out_cu2=(quant2+60)>>>SHIFT;
	out_cu3=(quant3-127)>>>SHIFT;
	out_cu4=(quant4-73)>>>SHIFT;
	*/
	out_cu1=(quant1)>>>SHIFT;
	out_cu2=(quant2)>>>SHIFT;
	out_cu3=(quant3)>>>SHIFT;
	out_cu4=(quant4)>>>SHIFT;
	

end

always@(*)
begin
	if (out_cu1[18] == 1'b1 && out_cu1 < 19'b111_1111_1111_1000_0001)
		out1 <= 8'b1000_0001;
	else if (out_cu1[18] == 1'b0 && out_cu1 > 19'b000_0000_0000_0111_1111)
		out1 <= 8'b0111_1111;
	else
		out1 <= out_cu1[7:0];

	if (out_cu2[18] == 1'b1 && out_cu2 < 19'b111_1111_1111_1000_0001)
		out2 <= 8'b1000_0001;
	else if (out_cu2[18] == 1'b0 && out_cu2 > 19'b000_0000_0000_0111_1111)
		out2 <= 8'b0111_1111;
	else
		out2 <= out_cu2[7:0];

	if (out_cu3[18] == 1'b1 && out_cu3 < 19'b111_1111_1111_1000_0001)
		out3 <= 8'b1000_0001;
	else if (out_cu3[18] == 1'b0 && out_cu3 > 19'b000_0000_0000_0111_1111)
		out3 <= 8'b0111_1111;
	else
		out3 <= out_cu3[7:0];

	if (out_cu4[18] == 1'b1 && out_cu4 < 19'b111_1111_1111_1000_0001)
		out4 <= 8'b1000_0001;
	else if (out_cu4[18] == 1'b0 && out_cu4 > 19'b000_0000_0000_0111_1111)
		out4 <= 8'b0111_1111;
	else
		out4 <= out_cu4[7:0];
end

endmodule