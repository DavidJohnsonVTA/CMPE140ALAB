`timescale 1ns/1ps

module tb_factorial_accelerator;
    reg clk;
    reg rst;
    reg go;
    reg [3:0] n;
    wire [31:0] result;
    wire done;
    wire error;

    factorial_accelerator DUT (
        .clk(clk), .rst(rst), .go(go), .n(n),
        .result(result), .done(done), .error(error)
    );

    always #1 clk = ~clk;

    task run_test;
        input [3:0] test_n;
        input [31:0] expected_result;
        input expected_error;
        begin
            @(negedge clk);
            n = test_n;
            go = 1'b1;

            wait (done || error);

            if (error !== expected_error)
                $display("FAIL n=%0d: error=%b expected=%b", test_n, error, expected_error);
            else if (!expected_error && result !== expected_result)
                $display("FAIL n=%0d: result=%h expected=%h", test_n, result, expected_result);
            else
                $display("PASS n=%0d: result=%h done=%b error=%b", test_n, result, done, error);

            @(negedge clk);
            go = 1'b0;
            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("factorial_accelerator.vcd");
        $dumpvars(0, tb_factorial_accelerator);

        clk = 1'b0;
        rst = 1'b1;
        go = 1'b0;
        n = 4'd0;

        repeat (2) @(posedge clk);
        rst = 1'b0;

        run_test(4'd0, 32'h00000001, 1'b0);
        run_test(4'd1, 32'h00000001, 1'b0);
        run_test(4'd2, 32'h00000002, 1'b0);
        run_test(4'd3, 32'h00000006, 1'b0);
        run_test(4'd4, 32'h00000018, 1'b0);
        run_test(4'd5, 32'h00000078, 1'b0);
        run_test(4'd6, 32'h000002D0, 1'b0);
        run_test(4'd7, 32'h000013B0, 1'b0);
        run_test(4'd8, 32'h00009D80, 1'b0);
        run_test(4'd9, 32'h00058980, 1'b0);
        run_test(4'd10, 32'h00375F00, 1'b0);
        run_test(4'd11, 32'h02611500, 1'b0);
        run_test(4'd12, 32'h1C8CFC00, 1'b0);
        run_test(4'd13, 32'h00000000, 1'b1);
        run_test(4'd14, 32'h00000000, 1'b1);

        $finish;
    end
endmodule
