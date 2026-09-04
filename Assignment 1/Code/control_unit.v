module control_unit (
    input  wire clk,
    input  wire rst,
    input  wire go,
    input  wire gt12,
    input  wire is_prime,
    input  wire cnt_gt_one,
    input  wire n_le_one,
    output reg  load_cnt,
    output reg  en_cnt,
    output reg  load_reg,
    output reg  sel1,
    output reg  sel2,
    output reg  done,
    output reg  error
);
    localparam S_IDLE  = 3'd0;
    localparam S_INIT  = 3'd1;
    localparam S_RUN   = 3'd2;
    localparam S_DONE  = 3'd3;
    localparam S_ERROR = 3'd4;

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (rst)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    always @* begin
        next_state = state;

        case (state)
            S_IDLE: begin
                if (go)
                    next_state = S_INIT;
            end

            S_INIT: begin
                if (gt12)
                    next_state = S_ERROR;
                else if (n_le_one)
                    next_state = S_DONE;
                else
                    next_state = S_RUN;
            end

            S_RUN: begin
                if (cnt_gt_one)
                    next_state = S_RUN;
                else
                    next_state = S_DONE;
            end

            S_DONE: begin
                if (!go)
                    next_state = S_IDLE;
            end

            S_ERROR: begin
                if (!go)
                    next_state = S_IDLE;
            end

            default: next_state = S_IDLE;
        endcase
    end

    always @* begin
        load_cnt = 1'b0;
        en_cnt   = 1'b0;
        load_reg = 1'b0;
        sel1     = 1'b0;
        sel2     = 1'b0;
        done     = 1'b0;
        error    = 1'b0;

        case (state)
            S_INIT: begin
                load_cnt = 1'b1;
                load_reg = 1'b1;
                sel1     = 1'b0;
            end

            S_RUN: begin
                en_cnt   = 1'b1;
                load_reg = 1'b1;
                sel1     = 1'b1;
            end

            S_DONE: begin
                sel2 = 1'b1;
                done = 1'b1;
            end

            S_ERROR: begin
                error = 1'b1;
            end

            default: begin
            end
        endcase
    end
endmodule
