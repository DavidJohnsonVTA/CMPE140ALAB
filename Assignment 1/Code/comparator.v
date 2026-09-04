module comparator #(parameter WIDTH = 4) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire             gt
);
    assign gt = (a > b);
endmodule
