`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/26 12:58:44
// Design Name: 
// Module Name: float_add_test_bench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module float_add_test_bench;
parameter float_width = 16;
parameter mantissa_width = 10;
parameter exponent_width = 5;
reg [float_width-1 : 0] float_a, float_b;
wire [float_width-1 : 0] res;
wire sign;
wire [exponent_width - 1 : 0] exponent;
wire [mantissa_width - 1 : 0] mantissa;
wire [mantissa_width : 0] myfraction;
assign sign = res[mantissa_width+exponent_width];
assign exponent = res[mantissa_width+exponent_width-1:mantissa_width];
assign mantissa = res[mantissa_width-1:0];

float_add inst_1(
.float_a(float_a),
.float_b(float_b),
.res(res),
.fraction(myfraction)
);

initial begin
    // 0.3 + 0.2 fail
	#0
	float_a = 16'h34CD;
	float_b = 16'h3266;

	// 0.3 + 0 correct
	#10
	float_a = 16'h34CD;
	float_b = 16'h3111;
	#10
    //0.3 + 0.3 fail
    float_a = 16'h34CD;
    float_b = 16'h34CD;
    #10
	$stop;
end

endmodule
