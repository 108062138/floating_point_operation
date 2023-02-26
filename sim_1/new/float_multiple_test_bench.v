`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/26 20:49:14
// Design Name: 
// Module Name: float_multiple
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


module float_multiple_test_bench;
parameter float_width = 16;
parameter exponent_width = 5;
parameter mantissa_width = 10;
reg [float_width-1:0] float_a;
reg [float_width-1:0] float_b;
wire [float_width-1:0] res;
wire [exponent_width-1:0] res_exponent;
wire [mantissa_width-1:0] res_mantissa;
wire [exponent_width-1:0] a_exponent;
wire [mantissa_width:0] a_fraction;
wire [exponent_width-1:0] b_exponent;
wire [mantissa_width:0] b_fraction;

assign res_exponent = res[mantissa_width+exponent_width-1:mantissa_width];
assign res_mantissa = res[mantissa_width-1:0];
assign a_exponent = float_a[mantissa_width+exponent_width-1:mantissa_width];
assign b_exponent = float_b[mantissa_width+exponent_width-1:mantissa_width];
assign a_fraction = {1'b1, float_a[mantissa_width-1:0]};
assign b_fraction = {1'b1, float_b[mantissa_width-1:0]};
float_multiple float_multiple_test_inst(.float_a(float_a), .float_b(float_b), .res(res));

initial begin
    #10
    float_a = 16'h3108;
    float_b = 16'h4003;
    #10
    float_a = 16'h6444;
    float_b = 16'h3333;
    #10
    float_a = 16'h2222;
    float_b = 16'h8888;
    #10
    float_a = 16'h3333;
    float_b = 16'h7777;
    #10
    float_a = 16'h6444;
    float_b = 16'h6666;
    #10
    $finish;
end

endmodule