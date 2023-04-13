`timescale 1ns / 1ps

module tb_rgb2y ();

parameter COLORDEPTH = 8;
parameter POWEREFF = 2;

reg                     clk =1;
reg                     rst =1;
wire [COLORDEPTH*3-1:0] rgb_i;
wire   [COLORDEPTH-1:0] gamma_o;


rgb2y #(
    .COLORDEPTH(COLORDEPTH),
    .POWEREFF(POWEREFF)
) uut (
    .clk(clk),
    .rst(rst),
    .rgb_i(rgb_i),
    .gamma_o(gamma_o),
    .dv_i(dv_i),
    .line_end(line_end)
);


always #5
   clk <= ~clk;

initial
begin
   rst <= 1;
   #102 
   rst <= 0;
end


reg [COLORDEPTH*3-1:0] rgb;
reg [COLORDEPTH*3-1:0] rgb_temp;
reg [COLORDEPTH*3-1:0] rgb_temp2;
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

assign rgb_i = rgb;

real result;
assign result = real'(gamma_o) -
                (   0.28125 *   real'(rgb_temp2[COLORDEPTH*3-1:COLORDEPTH*2])
                +   0.5625 *    real'(rgb_temp2[COLORDEPTH*2-1:COLORDEPTH])
                +   0.1171875 * real'(rgb_temp2[COLORDEPTH-1:0]));

endmodule