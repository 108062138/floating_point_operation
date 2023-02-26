`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/25 00:15:58
// Design Name: 
// Module Name: float_add
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


module float_add(
input wire [float_width - 1 : 0] float_a,
input wire [float_width - 1 : 0] float_b,
output reg [float_width - 1 : 0] res,
output reg [fraction_width:0] fraction
);

parameter float_width = 16;//1+5+10 = 16
parameter exponent_width = 5;
parameter mantissa_width = 10;
parameter fraction_width = 11;
parameter shift_width = exponent_width + 2;

reg [exponent_width - 1 : 0] exponent_a, exponent_b;
reg [fraction_width - 1/*fraction_width = mantissa_width + 1*/ : 0] fraction_a, fraction_b;
reg sign, cout;
reg signed [exponent_width - 1 + 1/*for we utilize this to hold +- exponent value*/:0] exponent;
reg [mantissa_width - 1 : 0] mantissa;
reg [shift_width - 1 : 0] shift_amount;

//this always block handles three varaible: exponent, fraction,res
always @(*) begin
    //init. assigned by if falls into NaN condition
    exponent_a = float_a[mantissa_width + exponent_width - 1 : mantissa_width];
    exponent_b = float_b[mantissa_width + exponent_width - 1 : mantissa_width];
    fraction_a = {1'b1, float_a[mantissa_width - 1 : 0]};
    fraction_b = {1'b1, float_b[mantissa_width - 1 : 0]};

    if(float_a == 0)begin
        res = float_b;
    end else if(float_b == 0)begin
        res = float_a;
    end else if((float_a[float_width - 2 : 0] == float_b[float_width - 2 : 0])  
    && (float_a[float_width-1] ^ float_b[float_width-1]==1'b1)) begin
        res = 0;
    end else begin
        //handle expontent and fraction_a/fraction_b if their corresponding exponent is not consist
        if(exponent_a > exponent_b)begin
            shift_amount = exponent_a - exponent_b;
            fraction_b = fraction_b >> (shift_amount);//for the fraction_b has no sign
            exponent = exponent_a;
        end else begin
            shift_amount = exponent_b - exponent_a;
            fraction_a = fraction_a >> (shift_amount);
            exponent = exponent_b;
        end

        //then let us consider in same sign and different sign
        if(float_a[float_width-1] == float_b[float_width-1])begin
            {cout, fraction} = fraction_a + fraction_b;
            if(cout)begin
                {cout, fraction} = {cout, fraction} >> 1;
                exponent = exponent + 1;
            end
            sign = float_a[float_width-1];
        end else begin
            if(float_a[float_width - 1])begin
                {cout, fraction} = fraction_b - fraction_a;
            end else begin
                {cout, fraction} = fraction_a - fraction_b;
            end
            sign = cout;
            //handle the case: 3 + (-7) = -4, we have to make it 4 s.t. the negative sign is stored into the sign bit 'sign'
            if(cout)begin
                fraction = -fraction;
            end
            //fit the IEEE754 standard that is to find the first 1 in the fraction part, plz
            if(fraction[mantissa_width] == 1'b0)begin
                if(fraction[mantissa_width-1] == 1)begin
                    fraction = fraction << 1;
                    exponent = exponent - 1;
                end else if(fraction[mantissa_width-2] == 1)begin
                    fraction = fraction << 2;
                    exponent = exponent - 2;
                end else if(fraction[mantissa_width-3] == 1)begin
                    fraction = fraction << 3;
                    exponent = exponent - 3;
                end else if(fraction[mantissa_width-4] == 1)begin
                    fraction = fraction << 4;
                    exponent = exponent - 4;
                end else if(fraction[mantissa_width-5] == 1)begin
                    fraction = fraction << 5;
                    exponent = exponent - 5;
                end else if(fraction[mantissa_width-6] == 1)begin
                    fraction = fraction << 6;
                    exponent = exponent - 6;
                end else if(fraction[mantissa_width-7] == 1)begin
                    fraction = fraction << 7;
                    exponent = exponent - 7;
                end else if(fraction[mantissa_width-8] == 1)begin
                    fraction = fraction << 8;
                    exponent = exponent - 8;
                end else if(fraction[mantissa_width-9] == 1)begin
                    fraction = fraction << 9;
                    exponent = exponent - 9;
                end else if(fraction[mantissa_width-10] == 1)begin
                    fraction = fraction << 10;
                    exponent = exponent - 10;
                end /*else if(fraction[mantissa_width-11] == 1)begin
                    fraction = fraction << 11;
                    exponent = exponent - 11;
                end else if(fraction[mantissa_width-12] == 1)begin
                    fraction = fraction << 12;
                    exponent = exponent - 12;
                end else if(fraction[mantissa_width-13] == 1)begin
                    fraction = fraction << 13;
                    exponent = exponent - 13;
                end else if(fraction[mantissa_width-14] == 1)begin
                    fraction = fraction << 14;
                    exponent = exponent - 14;
                end else if(fraction[mantissa_width-15] == 1)begin
                    fraction = fraction << 15;
                    exponent = exponent - 15;
                end else if(fraction[mantissa_width-16] == 1)begin
                    fraction = fraction << 16;
                    exponent = exponent - 16;
                end else if(fraction[mantissa_width-17] == 1)begin
                    fraction = fraction << 17;
                    exponent = exponent - 17;
                end else if(fraction[mantissa_width-18] == 1)begin
                    fraction = fraction << 18;
                    exponent = exponent - 18;
                end else if(fraction[mantissa_width-19] == 1)begin
                    fraction = fraction << 19;
                    exponent = exponent - 19;
                end else if(fraction[mantissa_width-20] == 1)begin
                    fraction = fraction << 20;
                    exponent = exponent - 20;
                end else if(fraction[mantissa_width-21] == 1)begin
                    fraction = fraction << 21;
                    exponent = exponent - 21;
                end else if(fraction[mantissa_width-22] == 1)begin
                    fraction = fraction << 22;
                    exponent = exponent - 22;
                end else if(fraction[mantissa_width-23] == 1)begin
                    fraction = fraction << 23;
                    exponent = exponent - 23;
                end*/
            end
        end

        mantissa = fraction[mantissa_width - 1:0];
        if(exponent[exponent_width])begin
            res = 0;
        end else begin
            res = {sign, exponent[exponent_width - 1 : 0], mantissa};
        end
    end
end

endmodule
