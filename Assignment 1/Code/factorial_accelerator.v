module factorial_accelerator (
    input  wire        clk,
    input  wire        rst,
    input  wire        go,
    input  wire [3:0]  n,
    output wire [31:0] result,
    output wire        done,
    output wire        error
);
    wire load_cnt, en_cnt, load_reg, sel1, sel2;
    wire gt12, is_prime, cnt_gt_one, n_le_one;

    control_unit U_CU (
        .clk(clk), .rst(rst), .go(go), .gt12(gt12),
        .is_prime(is_prime), .cnt_gt_one(cnt_gt_one), .n_le_one(n_le_one),
        .load_cnt(load_cnt), .en_cnt(en_cnt), .load_reg(load_reg),
        .sel1(sel1), .sel2(sel2), .done(done), .error(error)
    );

    datapath U_DP (
        .clk(clk), .rst(rst), .n(n),
        .load_cnt(load_cnt), .en_cnt(en_cnt), .load_reg(load_reg),
        .sel1(sel1), .sel2(sel2), .gt12(gt12), .is_prime(is_prime),
        .cnt_gt_one(cnt_gt_one), .n_le_one(n_le_one), .out(result)
    );
endmodule
