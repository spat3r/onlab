`timescale 1ns / 1ps

module tb_rgb2y ();

parameter COLORDEPTH = 8;
parameter POWEREFF = 2;

logic                   clk =1;
logic                   rst =1;
logic  [COLORDEPTH-1:0] red_i;
logic  [COLORDEPTH-1:0] green_i;
logic  [COLORDEPTH-1:0] blue_i;
logic  [COLORDEPTH-1:0] gamma_o;
logic        dv_i, dv_o;
logic        vs_i, vs_o;
logic        hs_i, hs_o;

rgb2y #(
    .COLORDEPTH(COLORDEPTH),
    .POWEREFF(POWEREFF)
) uut (
    .clk(clk),
    .rst(rst),
    .red_i(red_i),
    .green_i(green_i),
    .blue_i(blue_i),
    .gamma_o(gamma_o),
    .dv_i(dv_i),
    .hs_i(hs_i),
    .vs_i(vs_i),
    .dv_o(dv_o),
    .hs_o(hs_o),
    .vs_o(vs_o),
    .line_end_o(line_end)
);

vga_timing #(
    .H_VISIBLE(64),
    .V_VISIBLE(64),
    .H_FRONT_PORCH(3),
    .H_SYNC_PULSE(13),
    .H_BACK_PORCH(3)
    )timing (
        .clk(clk),
        .rst(rst),
        .h_sync(hs_i),
        .v_sync(vs_i),
        .blank(blank)
);
assign dv_i = ~blank;


always #5
   clk <= ~clk;

initial
begin
   rst <= 1;
   #102 
   rst <= 0;
end


logic[COLORDEPTH*3-1:0] rgb;
logic[COLORDEPTH*3-1:0] rgb_temp;
logic[COLORDEPTH*3-1:0] rgb_temp2;
always @(posedge clk) begin
    if (rst) begin
        rgb <= 0;
        rgb_temp <= 0;
        rgb_temp2 <= 0;
    end else begin
        rgb <= rgb + 1;
        rgb_temp <= rgb;
        rgb_temp2 <= rgb_temp;
    end
end

assign {red_i, green_i, blue_i} = rgb;

real result;
assign result = real'(gamma_o) -
                (   0.28125 *   real'(rgb_temp2[COLORDEPTH*3-1:COLORDEPTH*2])
                +   0.5625 *    real'(rgb_temp2[COLORDEPTH*2-1:COLORDEPTH])
                +   0.1171875 * real'(rgb_temp2[COLORDEPTH-1:0]));

endmodule

bind tb_rgb2y.uut rgb2y_assertions rgb2y_assertions_inst (
    clk, rst, red_i, green_i, blue_i, gamma_o, dv_i, hs_i, vs_i, dv_o, hs_o, vs_o, line_end_o );