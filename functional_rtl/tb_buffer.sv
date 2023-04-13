`timescale 1ns / 1ps

module tb_buffer();

parameter COLORDEPTH = 11;
parameter SCREENWIDTH = 1600;
reg clk = 1;
reg rst = 1;
reg datavalid;
wire [COLORDEPTH-1:0] data_i;
wire [COLORDEPTH-1:0] px_line_n2_o;
wire [COLORDEPTH-1:0] px_line_n1_o;
wire [COLORDEPTH-1:0] px_line_n0_o;

buffer #(
    .COLORDEPTH(COLORDEPTH),
    .SCREENWIDTH(SCREENWIDTH)
    ) uut (
    .clk            (clk),
    .rst            (rst),
    .datavalid      (datavalid),
    .data_i         (data_i),
    .px_line_n2_o   (px_line_n2_o),
    .px_line_n1_o   (px_line_n1_o),
    .px_line_n0_o   (px_line_n0_o)
);

always #5
   clk <= ~clk;

initial
begin
   rst <= 1;
   #102 
   rst <= 0;
end



reg [10:0] line_cntr;
reg [10:0] cntr;
wire addr_roll_over;
wire gen_roll_over;

always @(posedge clk) begin
    if (rst)
        cntr <= 0;
    else if (line_cntr[3] == 1'b0)
        cntr <= cntr + 1'b1;
    else if (line_cntr[3] == 1'b1)
        cntr <= cntr - 1'b1;
end

assign data_i = cntr[COLORDEPTH-1:0];

assign addr_roll_over = (cntr == (SCREENWIDTH-1) );
assign gen_roll_over = (cntr == 11'd2047);
always @(posedge clk) begin
    if (rst)
        line_cntr <= 0;
    else if (gen_roll_over)
        line_cntr <= line_cntr + 1;
end

always @(posedge clk) begin
    if (rst)
        datavalid <= 1;
    else if (gen_roll_over)
        datavalid <= 1;
    else if (addr_roll_over)
        datavalid <= 0;
end



endmodule
