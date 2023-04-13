module rgb2y #(
    parameter COLORDEPTH = 8,
    parameter POWEREFF = 2
) (
    input  wire        clk,
    input  wire        rst,
    input  wire [23:0] rgb_i,
    output wire [7:0]  gamma_o,
    input  wire        dv_i,
    input  wire        hs_i,
    input  wire        vs_i,
    output wire        dv_o,
    output wire        hs_o,
    output wire        vs_o,
    output wire        line_end
);

 wire [7:0] r, g, b;
 wire [7:0] r_mul, g_mul, b_mul;
 reg  [7:0] r_mul_ff, g_mul_ff, b_mul_ff;
 reg        dv_ff1;
 reg        hs_ff1;
 reg        vs_ff1;

 assign r = rgb_i [23:16];
 assign g = rgb_i [15:8];
 assign b = rgb_i [7:0];

 assign r_mul = (r >> 2) + (r >> 5);
 assign g_mul = (g >> 1) + (g >> 4);
 assign b_mul = (b >> 4) + (b >> 5);// + (b >> 6) + (b >> 7);

 always @(posedge clk ) begin
    if (rst) begin
        r_mul_ff <= 0;
        g_mul_ff <= 0;
        b_mul_ff <= 0;
        dv_ff1 <= 0;
        hs_ff1 <= 0;
        vs_ff1 <= 0;
    end else begin
        r_mul_ff <= r_mul;
        g_mul_ff <= g_mul;
        b_mul_ff <= b_mul;
        dv_ff1 <= dv_i;
        hs_ff1 <= hs_i;
        vs_ff1 <= vs_i;
    end
 end

 wire [7:0] gamma;
 reg  [7:0] gamma_ff;
 reg        dv_ff2;
 reg        dv_posedge;
 reg        vs_ff2;
 reg        hs_ff2;
 assign gamma = r_mul + g_mul + b_mul;
 
 always @(posedge clk ) begin
    if (rst) begin
        gamma_ff <= 0;
        dv_ff2 <= 0;
        dv_posedge <= 0;
        vs_ff2 <= 0;
        hs_ff2 <= 0;
    end else begin
        gamma_ff <= gamma;
        dv_ff2 <= dv_ff1;
        dv_posedge <= dv_i & ~dv_ff1;
        vs_ff2 <= vs_ff1;
        hs_ff2 <= hs_ff1;
    end
 end

 assign gamma_o = gamma_ff;
 assign dv_o = dv_ff2;
 assign line_end = dv_posedge;
 assign vs_o = vs_ff2;
 assign hs_o = vs_ff2;
    
endmodule
