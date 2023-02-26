`timescale 1ns / 1ps

module float_add(
input wire [float_width - 1 : 0] float_a,
input wire [float_width - 1 : 0] float_b,
output reg [float_width - 1 : 0] res
);

parameter float_width = 16;
parameter exponent_width = 5;
parameter mantissa_width = 10;

wire [exponent_width - 1: 0] exp_a, exp_b;
wire [mantissa_width - 1:0] man_a,man_b;
wire [mantissa_width:0] fraction_a, fraction_b;
reg [mantissa_width-1:0] res_mantissa;
reg [mantissa_width:0] shift_fraction_a, shift_fraction_b, fraction_sum;
reg [12:0] shiftAmount;
reg sign, cout_from_fraction_sum;
reg signed [exponent_width:0] exp_total, exp_un_add;

//construct fraction_a and fraction_b
assign exp_a = float_a[mantissa_width+exponent_width-1:mantissa_width];
assign exp_b = float_b[mantissa_width+exponent_width-1:mantissa_width];
assign man_a = float_a[mantissa_width-1:0];
assign man_b = float_b[mantissa_width-1:0];
assign fraction_a = {1'b1, man_a};
assign fraction_b = {1'b1, man_b};

always @(*) begin
    if(exp_a>exp_b)begin
        shiftAmount = exp_a - exp_b;
        shift_fraction_a = fraction_a;
        shift_fraction_b = fraction_b >> (shiftAmount);
        exp_un_add = exp_a;
    end else if(exp_a < exp_b) begin
        shiftAmount = exp_b - exp_a;
        shift_fraction_a = fraction_a >> (shiftAmount);
        shift_fraction_b = fraction_b;
        exp_un_add = exp_b;
    end else begin
        shiftAmount = 0;
        shift_fraction_a = fraction_a;
        shift_fraction_b = fraction_b;
        exp_un_add = exp_a;
    end
end


always @(*) begin
    //there are four type: float_a==0, float_b==0, float_a + float_b ==0, normal condition
    if(float_a==0)begin
        res = float_b;
    end else if(float_b==0) begin
        res = float_a;
    end else if(float_a[float_width-2:0]==float_b[float_width-2:0] && float_a[float_width-1]^float_b[float_width]==1'b1) begin
        res = 0;
    end else begin
        //consider their exponent: exp_a == exp_b, exp_a != exp_b
        if(float_a[float_width-1]==float_b[float_width-1])begin//same sign 
            {cout_from_fraction_sum, fraction_sum} = shift_fraction_a + shift_fraction_b;
            if(cout_from_fraction_sum == 1'b1)begin
                exp_total = exp_un_add + 1;
                {cout_from_fraction_sum, fraction_sum} = {cout_from_fraction_sum, fraction_sum} >>1 ;
            end else begin
                exp_total = exp_un_add;
            end
            sign = float_a[float_width-1];
        end else begin//different sign
            if(float_a[float_width-1] == 1'b1)begin
                {cout_from_fraction_sum, fraction_sum} = shift_fraction_b - shift_fraction_a;
            end else begin
                {cout_from_fraction_sum, fraction_sum} = shift_fraction_a - shift_fraction_b;
            end
            sign = cout_from_fraction_sum;
            if(sign == 1'b1)begin
                fraction_sum = -fraction_sum;
            end
            if(fraction_sum[mantissa_width]==1'b0)begin
                if(fraction_sum[mantissa_width-1]==1'b1)begin
                    fraction_sum = fraction_sum <<1;
                    exp_total = exp_un_add - 1;
                end else if(fraction_sum[mantissa_width-2]==1'b1) begin
                    fraction_sum = fraction_sum <<2;
                    exp_total = exp_un_add - 2;
                end else if(fraction_sum[mantissa_width-3]==1'b1) begin
                    fraction_sum = fraction_sum <<3;
                    exp_total = exp_un_add - 3;
                end else if(fraction_sum[mantissa_width-4]==1'b1) begin
                    fraction_sum = fraction_sum <<4;
                    exp_total = exp_un_add - 4;
                end else if(fraction_sum[mantissa_width-5]==1'b1) begin
                    fraction_sum = fraction_sum <<5;
                    exp_total = exp_un_add - 5;
                end else if(fraction_sum[mantissa_width-6]==1'b1) begin
                    fraction_sum = fraction_sum <<6;
                    exp_total = exp_un_add - 6;
                end else if(fraction_sum[mantissa_width-7]==1'b1) begin
                    fraction_sum = fraction_sum <<7;
                    exp_total = exp_un_add - 7;
                end else if(fraction_sum[mantissa_width-8]==1'b1) begin
                    fraction_sum = fraction_sum <<8;
                    exp_total = exp_un_add - 8;
                end  else if(fraction_sum[mantissa_width-9]==1'b1) begin
                    fraction_sum = fraction_sum <<9;
                    exp_total = exp_un_add - 9;
                end  else if(fraction_sum[mantissa_width-10]==1'b1) begin
                    fraction_sum = fraction_sum <<10;
                    exp_total = exp_un_add - 10;
                end
            end else begin
                exp_total = exp_un_add;
            end
        end

        res_mantissa = fraction_sum[mantissa_width-1:0];
        if(exp_total[exponent_width] == 1'b1)begin
            res = 0;
        end else begin
            res = {sign, exp_total[exponent_width-1:0], res_mantissa};
        end
    end
end

endmodule
