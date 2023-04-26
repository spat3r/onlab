module rgb2y #(
    parameter COLORDEPTH = 8,
    parameter POWEREFF = 2
    ) (
    input  logic       clk,
    input  logic       rst,
    input  logic[23:0] rgb_i,
    output logic[7:0]  gamma_o,
    input  logic       dv_i,
    input  logic       hs_i,
    input  logic       vs_i,
    output logic       dv_o,
    output logic       hs_o,
    output logic       vs_o,
    output logic       line_end_o
    );

    logic[7:0] r, g, b;
    logic[7:0] r_mul_d, g_mul_d, b_mul_d;
    logic[7:0] r_mul_q, g_mul_q, b_mul_q;

    assign r = dv_i ? rgb_i [23:16] : 8'b0;
    assign g = dv_i ? rgb_i [15:8]  : 8'b0;
    assign b = dv_i ? rgb_i [7:0]   : 8'b0;

    assign r_mul_d = (r >> 2) + (r >> 5);
    assign g_mul_d = (g >> 1) + (g >> 4);
    assign b_mul_d = (b >> 4) + (b >> 5); // + (b >> 6) + (b >> 7);
    
    always @(posedge clk ) begin
        if (rst) begin
            r_mul_q <= 0;
            g_mul_q <= 0;
            b_mul_q <= 0;
        end else begin
            r_mul_q <= r_mul_d;
            g_mul_q <= g_mul_d;
            b_mul_q <= b_mul_d;
        end
    end
    
    logic[7:0] gamma_d;
    assign gamma_d = (r_mul_q + g_mul_q + b_mul_q);
    //data route, no need for any reset
    always @(posedge clk ) begin
        gamma_o <= gamma_d;
    end

    logic [1:0] dv_shr;
    logic [1:0] hs_shr;
    logic [1:0] vs_shr;
    wire  line_end_d = dv_shr[0] & ~dv_i;

    always_ff @(posedge clk) begin
        if (rst) begin
            dv_shr <= 0;
            hs_shr <= 0;
            vs_shr <= 0;
        end else begin
            dv_shr <= {dv_shr[0],dv_i};
            hs_shr <= {hs_shr[0],hs_i};
            vs_shr <= {vs_shr[0],vs_i};
            line_end_o <= line_end_d;
            dv_o <= dv_shr[0];
            hs_o <= hs_shr[0];
            vs_o <= vs_shr[0];
        end
    end

endmodule
