`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/26 17:13:54
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


module float_multiple(
input wire [float_width-1:0] float_a,
input wire [float_width-1:0] float_b,
output reg [float_width-1:0] res
);

parameter float_width = 16;
parameter exponent_width = 5;
parameter mantissa_width = 10;
wire [exponent_width-1:0] exp_a, exp_b;
reg [exponent_width:0] res_exponent;
wire [mantissa_width-1:0] man_a, man_b;
wire [mantissa_width:0] fraction_a, fraction_b;
wire [2*mantissa_width+1:0] fraction_un_process;
reg [2*mantissa_width+1:0] fraction_shift;
wire [exponent_width:0] exp_un_process;
reg [mantissa_width-1:0] res_mantissa;
reg sign;

assign exp_a = float_a[mantissa_width+exponent_width-1:mantissa_width];
assign exp_b = float_b[mantissa_width+exponent_width-1:mantissa_width];
assign man_a = float_a[mantissa_width-1:0];
assign man_b = float_b[mantissa_width-1:0];
assign fraction_a = {1'b1, man_a};
assign fraction_b = {1'b1, man_b};
assign exp_un_process = exp_a + exp_b - (2**(exponent_width-1)-1) + 2;
assign fraction_un_process = fraction_a * fraction_b;

always @(*) begin
    if(float_a==0 || float_b==0)begin
        res = 0;
    end else begin
        sign = float_a[float_width-1] ^ float_b[float_width-1];

        if(fraction_un_process[2*mantissa_width+1] == 1'b1)begin
            fraction_shift = fraction_un_process << 1;
            res_exponent = exp_un_process - 1;
        end else if(fraction_un_process[2*mantissa_width+0] == 1'b1)begin
            fraction_shift = fraction_un_process << 2;
            res_exponent = exp_un_process - 2;
        end else if(fraction_un_process[2*mantissa_width-1] == 1'b1)begin
            fraction_shift = fraction_un_process << 3;
            res_exponent = exp_un_process - 3;
        end else if(fraction_un_process[2*mantissa_width-2] == 1'b1)begin
            fraction_shift = fraction_un_process << 4;
            res_exponent = exp_un_process - 4;
        end else if(fraction_un_process[2*mantissa_width-3] == 1'b1)begin
            fraction_shift = fraction_un_process << 5;
            res_exponent = exp_un_process - 5;
        end else if(fraction_un_process[2*mantissa_width-4] == 1'b1)begin
            fraction_shift = fraction_un_process << 6;
            res_exponent = exp_un_process - 6;
        end else if(fraction_un_process[2*mantissa_width-5] == 1'b1)begin
            fraction_shift = fraction_un_process << 7;
            res_exponent = exp_un_process - 7;
        end else if(fraction_un_process[2*mantissa_width-6] == 1'b1)begin
            fraction_shift = fraction_un_process << 8;
            res_exponent = exp_un_process - 8;
        end else if(fraction_un_process[2*mantissa_width-7] == 1'b1)begin
            fraction_shift = fraction_un_process << 9;
            res_exponent = exp_un_process - 9;
        end else if(fraction_un_process[2*mantissa_width-8] == 1'b1)begin
            fraction_shift = fraction_un_process << 10;
            res_exponent = exp_un_process - 10;
        end

        res_mantissa = fraction_shift[2*mantissa_width+1:mantissa_width+2];
        if(res_exponent[exponent_width] == 1'b1)begin
            res = 0;
        end else begin
            res = {sign, res_exponent[exponent_width-1:0], res_mantissa};
        end
    end
end
endmodule
