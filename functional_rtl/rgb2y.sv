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
    output logic       line_end
    );

    logic[7:0] r, g, b;
    logic[7:0] r_mul_d, g_mul_d, b_mul_d;
    logic[7:0] r_mul_q, g_mul_q, b_mul_q;

    assign r = rgb_i [23:16];
    assign g = rgb_i [15:8];
    assign b = rgb_i [7:0];

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
    
    assign gamma = dv_q1 ? (r_mul + g_mul + b_mul) : 7'b0;
    assign dv_posedge = dv_i & ~dv_q1;
    
    //data route, no need for any reset
    always @(posedge clk ) begin
        gamma_o <= gamma;
    end

    logic [1:0] dv_shr;
    logic [1:0] hs_shr;
    logic [1:0] vs_shr;

    always_ff @(posedge clk) begin
        if (rst) begin
            dv_shr <= 0;
            hs_shr <= 0;
            vs_shr <= 0;
        end else begin
            dv_shr <= {dv_shr[0],dv_i};
            hs_shr <= {hs_shr[0],hs_i};
            vs_shr <= {vs_shr[0],vs_i};
            dv_o <= dv_shr[1];
            hs_o <= hs_shr[1];
            vs_o <= vs_shr[1];
        end
    end

endmodule
