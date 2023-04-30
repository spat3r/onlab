module sobel_top (
    input  logic        clk,
    input  logic        rst,
    input  logic  [7:0] red_i,
    input  logic  [7:0] green_i,
    input  logic  [7:0] blue_i,
    input  logic        dv_i,
    input  logic        hs_i,
    input  logic        vs_i,
    output logic  [7:0] red_o,
    output logic  [7:0] green_o,
    output logic  [7:0] blue_o,
    output logic        dv_o,
    output logic        hs_o,
    output logic        vs_o
);


logic [23:0] rgb_i;
assign rgb_i = { red_i, green_i, blue_i};

logic [7:0] gamma_o;

logic dv_rgb_o;
logic line_end_gb;
logic line_end_blur;
logic [7:0] gb_line_o [2:0];

rgb2y_3 #(
    .COLORDEPTH(8)
) rgb2y_inst (
    .clk(clk),
    .rst(rst),
    .rgb_i(rgb_i),
    .gamma_o(gamma_o),
    .dv_i(dv_i),
    .dv_o(dv_rgb_o),
    .line_end_o(line_end_gb)
);

buffer #(
    .COLORDEPTH(8)
) gray_buff_inst (
    .clk            (clk),
    .rst            (rst),
    .data_i         (gamma_o),
    .dv_i           (dv_rgb_o),
    .line_end       (line_end_gb),
    .dv_o           (dv_gb_o),
    .buff_o         (gb_line_o)
);
convolution #(
    .COLORDEPTH(8)
) blur_inst (
    .clk(clk),
    .rst(rst),
    .vect_in(gb_line_o),
    .conv_o(conv_o),
    .line_end(line_end_blur),
    .vs_i(vs_i),
    .dv_i(dv_gb_o),
    .dv_o(dv_blur_o)  
);



logic [15:0] hs_shr, vs_shr;
assign dv_out = dv_blur_o;
always @ ( posedge clk ) begin
    dv_o    <= dv_out;
    hs_shr <= {hs_shr[2:0], hs_i};
    if ( ~hs_o & hs_shr[2])
        vs_shr <= {vs_shr[2:0], vs_i};
    hs_o    <= hs_shr[2];
    vs_o    <= vs_shr[2];
    red_o   <= dv_out ? gb_line_o[2] : 8'b0;
    green_o <= dv_out ? gb_line_o[2] : 8'b0;
    blue_o  <= dv_out ? gb_line_o[2] : 8'b0;
end



endmodule