module datapath #(parameter WIDTH = 32) (
    input  wire             clk,
    input  wire             rst,
    input  wire [3:0]       n,
    input  wire             load_cnt,
    input  wire             en_cnt,
    input  wire             load_reg,
    input  wire             sel1,
    input  wire             sel2,
    output wire             gt12,
    output wire             is_prime,
    output wire             cnt_gt_one,
    output wire             n_le_one,
    output wire [WIDTH-1:0] out
);
    wire [WIDTH-1:0] n_extended;
    wire [WIDTH-1:0] cnt_out;
    wire [WIDTH-1:0] reg_out;
    wire [WIDTH-1:0] mul_out;
    wire [WIDTH-1:0] reg_input;
    wire [WIDTH-1:0] output_value;

    assign n_extended = {{(WIDTH-4){1'b0}}, n};

    counter #(WIDTH) U_CNT (
        .clk(clk), .rst(rst), .load_cnt(load_cnt), .en_cnt(en_cnt),
        .d(n_extended), .q(cnt_out)
    );

    multiplier #(WIDTH) U_MUL (
        .a(cnt_out), .b(reg_out), .product(mul_out)
    );

    mux2 #(WIDTH) U_MUX1 (
        .in0({{(WIDTH-1){1'b0}}, 1'b1}),
        .in1(mul_out), .sel(sel1), .out(reg_input)
    );

    data_register #(WIDTH) U_REG (
        .clk(clk), .rst(rst), .load_reg(load_reg),
        .d(reg_input), .q(reg_out)
    );

    mux2 #(WIDTH) U_MUX2 (
        .in0({WIDTH{1'b0}}), .in1(reg_out),
        .sel(sel2), .out(output_value)
    );

    comparator #(4) U_CMP (
        .a(n), .b(4'd12), .gt(gt12)
    );

    prime_number #(4) U_PRIME (
        .number(n), .is_prime(is_prime)
    );

    assign cnt_gt_one = (cnt_out > 32'd1);
    assign n_le_one = (n <= 4'd1);
    assign out = output_value;
endmodule
