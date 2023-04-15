module sobel_top (
    input wire clk,
    input wire rst,
    input  wire [7:0] red_i,
    input  wire [7:0] green_i,
    input  wire [7:0] blue_i,
    input wire dv_i,
    input wire hs_i,
    input wire vs_i,
    output reg  [7:0] red_o,
    output reg  [7:0] green_o,
    output reg  [7:0] blue_o,
    output reg  dv_o,
    output reg  hs_o,
    output reg  vs_o
);


wire [23:0] rgb_i;
assign rgb_i = { red_i, green_i, blue_i};

wire [7:0] gamma_o;

wire dv_rgb_o;
wire line_end;
wire [23:0] gb_line_o;

rgb2y #(
    .COLORDEPTH(8)
) rgb2y_inst (
    .clk(clk),
    .rst(rst),
    .rgb_i(rgb_i),
    .gamma_o(gamma_o),
    .dv_i(dv_i),
    .dv_o(dv_rgb_o),
    .line_end(line_end)
);

buffer #(
    .COLORDEPTH(8)
) gray_buff (
    .clk            (clk),
    .rst            (rst),
    .data_i         (gamma_o),
    .dv_i           (dv_rgb_o),
    .line_end       (line_end),
    .dv_o           (dv_gb_o),
    .buff_o         (gb_line_o)
);

reg [3:0] hs_shr, vs_shr;
assign dv_out = dv_gb_o;
always @ ( posedge clk )
begin
   dv_o    <= dv_out;
   hs_shr <= {hs_shr[2:0], hs_i};
   vs_shr <= {vs_shr[2:0], vs_i};
   hs_o    <= hs_shr[2];
   vs_o    <= vs_shr[2];
   red_o   <= dv_out ? gb_line_o[23:16] : 8'b0;
   green_o <= dv_out ? gb_line_o[23:16] : 8'b0;
   blue_o  <= dv_out ? gb_line_o[23:16] : 8'b0;
end



endmodule