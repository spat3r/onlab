`timescale 1ns / 1ps

module tb_sobel_top ();

parameter COLORDEPTH = 8;
parameter POWEREFF = 2;
parameter SCREENHEIGHT = 64;
parameter SCREENWIDTH = 64;
parameter POL_VS = 1;
parameter POL_HS = 1;

logic rx_clk = 0;    // pixelclock, @1600x900 60Hz : XXX MHz
parameter RX_CLK_PERIOD_DELAY   = 10.025;

logic [7:0] led_r;
logic [7:0] switch;
logic [3:0] bt;
logic rstbt;     // rstbutton, FPGA dedicated RST button

logic        DUV_dv_i, DUV_dv_o, VGA_dv;
logic        DUV_vs_i, DUV_vs_o, VGA_vs;
logic        DUV_hs_i, DUV_hs_o, VGA_hs;
logic        blank;
logic [11:0] v_cnt, h_cnt;
logic  [7:0] DUV_red_i,    DUV_red_o;
logic  [7:0] DUV_green_i,  DUV_green_o;
logic  [7:0] DUV_blue_i,   DUV_blue_o;

always #5 rx_clk <= ~rx_clk;

initial begin
    rstbt <= 0;
    #15
    rstbt <= 1;
    #214 
    rstbt <= 0;
    switch <= 5'd4;

    @(posedge DUV_vs_o)
    @(negedge DUV_vs_o)
    @(posedge DUV_hs_o)
    $stop;
end

regressionTester #(
    .VRES(SCREENHEIGHT),
    .HRES(SCREENWIDTH)
) rgtr_inst (
    .clk        ( rx_clk          ),
    .rst        ( rstbt           ),
    .h_cnt      ( h_cnt           ),
    .v_cnt      ( v_cnt           ),
    .vga_dv_o   ( VGA_dv          ),
    .vga_hs_o   ( VGA_hs          ),
    .vga_vs_o   ( VGA_vs          ),

    .tb_red_o   ( DUV_red_o       ),
    .tb_green_o ( DUV_green_o     ),
    .tb_blue_o  ( DUV_blue_o      ),
    .tb_dv_o    ( DUV_dv_o        ),
    .tb_hs_o    ( DUV_hs_o        ),
    .tb_vs_o    ( DUV_vs_o        ),

    .tb_red_i   ( DUV_red_i       ),
    .tb_green_i ( DUV_green_i     ),
    .tb_blue_i  ( DUV_blue_i      ),
    .tb_dv_i    ( DUV_dv_i        ),
    .tb_hs_i    ( DUV_hs_i        ),
    .tb_vs_i    ( DUV_vs_i        )
);

sobel_top #(
        .COLORDEPTH(COLORDEPTH),
        .SCREENWIDTH(SCREENWIDTH),
        .POL_VS(POL_VS),
        .POL_HS(POL_HS)
    ) sobel_top_inst (
        .clk      ( rx_clk        ),
        .rst      ( rstbt         ),
        .sw       ( switch        ),
        .red_i    ( DUV_red_i     ),
        .green_i  ( DUV_green_i   ),
        .blue_i   ( DUV_blue_i    ),
        .red_o    ( DUV_red_o     ),
        .green_o  ( DUV_green_o   ),
        .blue_o   ( DUV_blue_o    ),
        .dv_i     ( DUV_dv_i      ),
        .hs_i     ( DUV_hs_i      ),
        .vs_i     ( DUV_vs_i      ),
        .dv_o     ( DUV_dv_o      ),
        .hs_o     ( DUV_hs_o      ),
        .vs_o     ( DUV_vs_o      )
    );

vga_timing #(
        .H_VISIBLE     ( SCREENWIDTH ),
        .V_VISIBLE     ( SCREENHEIGHT ),
        .H_FRONT_PORCH ( 3  ),
        .H_SYNC_PULSE  ( 13 ),
        .H_BACK_PORCH  ( 3  )
    )timing (
        .clk        ( rx_clk ),
        .rst        ( rstbt  ),
        .h_sync     ( VGA_hs ),
        .v_sync     ( VGA_vs ),
        .h_cnt      ( h_cnt  ),
        .v_cnt      ( v_cnt  ),
        .blank      ( blank  )
);
assign VGA_dv = ~blank;




// logic [23:0] rgb;
// // rgb data gen
// always_ff @(posedge rx_clk) begin
//     rgb <= ( v_cnt[2]  ) ? 24'hFFFFFF : 24'h0; // ^ v_cnt[0]
//     // if (rst) rgb <= 23'had98b7;
//     // else rgb <= { rgb[22:0], rgb[3] ^ rgb[8] ^ rgb[13] ^ rgb[22]}; 
// end

// assign {red_i, green_i, blue_i} = dv_i ? rgb : 24'b0;

endmodule