module prime_number #(parameter WIDTH = 4) (
    input  wire [WIDTH-1:0] number,
    output reg              is_prime
);
    integer i;
    reg divisible;

    always @* begin
        is_prime = 1'b1;
        divisible = 1'b0;

        if (number < 2) begin
            is_prime = 1'b0;
        end
        else begin
            for (i = 2; i < (1 << WIDTH); i = i + 1) begin
                if ((number % i) == 0 && number != i)
                    divisible = 1'b1;
            end
            if (divisible)
                is_prime = 1'b0;
        end
    end
endmodule
