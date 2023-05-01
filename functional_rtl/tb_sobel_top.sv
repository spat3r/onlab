`timescale 1ns / 1ps

module tb_sobel_top ();

parameter COLORDEPTH = 8;
parameter POWEREFF = 2;

reg         clk =1;
reg         rst =1;
wire [23:0] rgb_i;
wire [23:0]  rgb_o;
wire        dv_i;
wire        hs_i;
wire        vs_i, vs_o;

always #5
   clk <= ~clk;

initial
begin
   rst <= 1;
   #102 
   rst <= 0;

   @(posedge vs_o)
   @(negedge vs_o)
   @(posedge hs_o)
   $stop;
end



sobel_top #(
    ) sobel_top_inst (
        .clk(clk),
        .rst(rst),
        .red_i(rgb_i [23:16]),
        .green_i(rgb_i [15:8]),
        .blue_i(rgb_i [7:0]),
        .red_o(rgb_o [23:16]),
        .green_o(rgb_o [15:8]),
        .blue_o(rgb_o [7:0]),
        .dv_i(dv_i),
        .hs_i(hs_i),
        .vs_i(vs_i),
        .dv_o(dv_o),
        .hs_o(hs_o),
        .vs_o(vs_o)
    );

vga_timing #(
    )timing (
        .clk(clk),
        .rst(rst),
        .h_sync(hs_i),
        .v_sync(vs_i),
        .blank(blank)
);
assign dv_i = ~blank;


reg [23:0] rgb;
// rgb data gen
always @(posedge clk) begin
    if (rst) 
        rgb <= 23'had98b7;
    else
        rgb <= { rgb[22:0], rgb[3] ^ rgb[8] ^ rgb[13] ^ rgb[22]};
    
end
assign rgb_i = rgb;

// always @(posedge clk) begin
//     if (rst) begin
//         rgb <= 0;
//     end else begin
//         rgb <= rgb + 1;
//     end
// end


endmodule