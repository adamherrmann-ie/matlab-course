module rs (
input logic block1_clk,
input logic d,
input logic block1_rstn,
output logic q
);

always @ (posedge block1_clk or negedge block1_rstn)
	if (~block1_rstn)
		q <= 1'b0;
	else
		q <= d;

endmodule
