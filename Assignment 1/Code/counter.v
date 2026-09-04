module counter #(parameter WIDTH = 32) (
    input  wire             clk,
    input  wire             rst,
    input  wire             load_cnt,
    input  wire             en_cnt,
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= {WIDTH{1'b0}};
        else if (load_cnt)
            q <= d;
        else if (en_cnt)
            q <= q - 1'b1;
    end
endmodule
