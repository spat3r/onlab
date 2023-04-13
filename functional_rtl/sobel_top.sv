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
wire px_line_n2_o;
wire px_line_n1_o;
wire px_line_n0_o;

rgb2y #(
    .COLORDEPTH(8)
) rgb2y_inst (
    .clk(clk),
    .rst(rst),
    .rgb_i(rgb_i),
    .gamma_o(gamma_o),
    .dv_i(dv_i),
    // .hs_i(hs_i),
    // .vs_i(vs_i),
    .dv_o(dv_rgb_o),
    // .hs_o(hs_o),
    // .vs_o(vs_o),
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
    // .dv_o           (dv_o),
    .px_line_n2_o   (px_line_n2_o),
    .px_line_n1_o   (px_line_n1_o),
    .px_line_n0_o   (px_line_n0_o)
);


always @ ( posedge clk )
begin
   dv_o    <= dv_i;
   hs_o    <= hs_i;
   vs_o    <= vs_i;
   red_o   <= gamma_o;
   green_o <= gamma_o;
   blue_o  <= gamma_o;
end



endmodule