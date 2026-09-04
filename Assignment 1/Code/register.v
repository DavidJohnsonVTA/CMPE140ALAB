module data_register #(parameter WIDTH = 32) (
    input  wire             clk,
    input  wire             rst,
    input  wire             load_reg,
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= {WIDTH{1'b0}};
        else if (load_reg)
            q <= d;
    end
endmodule
