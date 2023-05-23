`timescale 1ns / 1ps

module tb_buffer();

parameter COLORDEPTH = 11;
parameter SCREENWIDTH = 25;
parameter BUF_DEPTH = 5;
logic clk = 1;
logic rst = 1;
logic dv_i, hs_i, vs_i;
logic [COLORDEPTH-1:0] data_i;
logic [COLORDEPTH-1:0] buff_o [BUF_DEPTH-1:0];

always #5
   clk <= ~clk;

initial
begin
   rst <= 1;
   #102 
   rst <= 0;
end


logic [10:0] cntr;
reg [23:0] rgb;

// rgb data gen
always @(posedge clk) begin
    if (rst) 
        rgb <= 23'had98b7;
    else
        rgb <= { rgb[22:0], rgb[3] ^ rgb[8] ^ rgb[13] ^ rgb[22]};
end

vga_timing #(
        .H_VISIBLE(SCREENWIDTH)
    )timing (
        .clk(clk),
        .rst(rst),
        .h_sync(hs_i),
        .v_sync(vs_i),
        .h_cnt(cntr),
        .blank(blank)
);
assign dv_i = ~blank;
assign data_i = dv_i ?  rgb[COLORDEPTH-1:0] : 0;


buffer #(
    .COLORDEPTH(COLORDEPTH),
    .SCREENWIDTH(SCREENWIDTH),
    .BUF_DEPTH(BUF_DEPTH)
   ) gray_buff_inst (
    .clk            (clk),
    .rst            (rst),
    .data_i         (data_i),
    .dv_i           (dv_i),
    .hs_i           (hs_i),
    .vs_i           (vs_i),
    .dv_o           (dv_o),
    .hs_o           (hs_o),
    .vs_o           (vs_o),
    .line_end_i     (line_end),
    .buff_o         (gb_line_o)
);

endmodule
