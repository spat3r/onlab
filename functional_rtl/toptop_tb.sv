module toptop_tb ();

logic clk100M = 0;   // 100 MHz
parameter CLK100M_PERIOD_DELAY  = 10.025;
logic clk200M = 0;   // 200 MHz for IDELAY
parameter CLK200M_PERIOD_DELAY  = 10.025;
logic rx_clk = 0;    // pixelclock, @1600x900 60Hz : XXX MHz
parameter RX_CLK_PERIOD_DELAY   = 10.025;
logic rx_clk_5x = 0; // 5x pixelclk
parameter RX_CLK_5X_PERIOD_DELAY= 10.025;

always #(CLK100M_PERIOD_DELAY)   clk100M   <= ~clk100M;
always #(CLK200M_PERIOD_DELAY)   clk200M   <= ~clk200M;
always #(RX_CLK_PERIOD_DELAY)    rx_clk    <= ~rx_clk;
always #(RX_CLK_5X_PERIOD_DELAY) rx_clk_5x <= ~rx_clk_5x;

logic rstbt;     // rstbutton, FPGA dedicated RST button

logic [7:0] led_r;
logic [7:0] sw;
logic [3:0] bt;

logic        DUV_dv_i, DUV_dv_o, VGA_dv;
logic        DUV_vs_i, DUV_vs_o, VGA_vs;
logic        DUV_hs_i, DUV_hs_o, VGA_hs;
logic        blank;
logic [11:0] v_cnt, h_cnt;
logic  [7:0] DUV_red_i,    DUV_red_o;
logic  [7:0] DUV_green_i,  DUV_green_o;
logic  [7:0] DUV_blue_i,   DUV_blue_o;

initial begin
    rstbt <= 1;
    #214 
    rstbt <= 0;
    sw <= 5'd16;

    @(posedge DUV_vs_o)
    @(negedge DUV_vs_o)
    @(posedge DUV_hs_o)
    @(posedge DUV_vs_o)
    @(negedge DUV_vs_o)
    @(posedge DUV_hs_o)
    $stop;
end

vga_timing #(
    .H_VISIBLE(64),
    .V_VISIBLE(64),
    .H_FRONT_PORCH(3),
    .H_SYNC_PULSE(13),
    .H_BACK_PORCH(3)
    )timing (
        .clk(rx_clk),
        .rst(rstbt ),
        .h_sync(VGA_hs),
        .v_sync(VGA_vs),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .blank(blank)
);

assign VGA_dv = ~blank;

regressionTester #(
    .VRES(900),
    .HRES(1600)
) rgtr_inst (
    .clk        (rx_clk),
    .rst        (rstbt  ),
    .h_cnt      ( h_cnt           ),
    .v_cnt      ( v_cnt           ),
    .vga_dv_i   ( VGA_dv          ),
    .vga_hs_i   ( VGA_hs          ),
    .vga_vs_i   ( VGA_vs          ),

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

hdmi_tx hdmi_tx_tb(
   .tx_clk        ( rx_clk        ),
   .tx_clk_5x     ( rx_clk_5x     ),
   .rst           ( rstbt         ),

   .tx_red        ( DUV_red_i     ),
   .tx_green      ( DUV_green_i   ),
   .tx_blue       ( DUV_blue_i    ),
   .tx_dv         ( DUV_dv_i      ),
   .tx_hs         ( DUV_hs_i      ),
   .tx_vs         ( DUV_vs_i      ),

   .hdmi_tx_clk_p ( hdmi_tx_clk_p ),
   .hdmi_tx_clk_n ( hdmi_tx_clk_n ),
   .hdmi_tx_d0_p  ( hdmi_tx_d0_p  ),
   .hdmi_tx_d0_n  ( hdmi_tx_d0_n  ),
   .hdmi_tx_d1_p  ( hdmi_tx_d1_p  ),
   .hdmi_tx_d1_n  ( hdmi_tx_d1_n  ),
   .hdmi_tx_d2_p  ( hdmi_tx_d2_p  ),
   .hdmi_tx_d2_n  ( hdmi_tx_d2_n  )
);

// design under verification
hdmi_top DUV(
   .clk100M       ( clk100M       ),
   .rstbt         ( rstbt         ),
   .led_r         ( led_r         ),
   .sw            ( sw            ),
   .bt            ( bt            ),

   .hdmi_rx_d0_p  ( hdmi_tx_d0_p  ),
   .hdmi_rx_d0_n  ( hdmi_tx_d0_n  ),
   .hdmi_rx_d1_p  ( hdmi_tx_d1_p  ),
   .hdmi_rx_d1_n  ( hdmi_tx_d1_n  ),
   .hdmi_rx_d2_p  ( hdmi_tx_d2_p  ),
   .hdmi_rx_d2_n  ( hdmi_tx_d2_n  ),
   .hdmi_rx_clk_p ( hdmi_tx_clk_p ),
   .hdmi_rx_clk_n ( hdmi_tx_clk_n ),
   .hdmi_rx_cec   ( hdmi_tx_cec   ),
   .hdmi_rx_hpd   ( hdmi_tx_hpd   ),
   .hdmi_rx_scl   ( hdmi_tx_scl   ),
   .hdmi_rx_sda   ( hdmi_tx_sda   ),

   .hdmi_tx_d0_p  ( hdmi_rx_d0_p  ),
   .hdmi_tx_d0_n  ( hdmi_rx_d0_n  ),
   .hdmi_tx_d1_p  ( hdmi_rx_d1_p  ),
   .hdmi_tx_d1_n  ( hdmi_rx_d1_n  ),
   .hdmi_tx_d2_p  ( hdmi_rx_d2_p  ),
   .hdmi_tx_d2_n  ( hdmi_rx_d2_n  ),
   .hdmi_tx_clk_p ( hdmi_rx_clk_p ),
   .hdmi_tx_clk_n ( hdmi_rx_clk_n ),
   .hdmi_tx_cec   ( hdmi_rx_cec   ),
   .hdmi_tx_hpdn  ( hdmi_rx_hpdn  ),
   .hdmi_tx_scl   ( hdmi_rx_scl   ),
   .hdmi_tx_sda   ( hdmi_rx_sda   )
);

// this receiver translates the data from DUV
hdmi_rx hdmi_rx_tb(
   .clk_200M      ( clk_200M      ),
   .rst           ( rstbt         ),

   .hdmi_rx_cec   ( hdmi_rx_cec   ),
   .hdmi_rx_hpd   ( hdmi_rx_hpd   ),
   .hdmi_rx_scl   ( hdmi_rx_scl   ),
   .hdmi_rx_sda   ( hdmi_rx_sda   ),
   .hdmi_rx_clk_p ( hdmi_rx_clk_p ),
   .hdmi_rx_clk_n ( hdmi_rx_clk_n ),
   .hdmi_rx_d0_p  ( hdmi_rx_d0_p  ),
   .hdmi_rx_d0_n  ( hdmi_rx_d0_n  ),
   .hdmi_rx_d1_p  ( hdmi_rx_d1_p  ),
   .hdmi_rx_d1_n  ( hdmi_rx_d1_n  ),
   .hdmi_rx_d2_p  ( hdmi_rx_d2_p  ),
   .hdmi_rx_d2_n  ( hdmi_rx_d2_n  ),
   .rx_clk        ( rx_tb_clk     ),
   .rx_clk_5x     ( rx_tb_clk_5x  ),

   .rx_red        ( DUV_red_o     ),
   .rx_green      ( DUV_green_o   ),
   .rx_blue       ( DUV_blue_o    ),
   .rx_dv         ( DUV_dv_o      ),
   .rx_hs         ( DUV_hs_o      ),
   .rx_vs         ( DUV_vs_o      ),
   .rx_status     ( rx_status     )
);

endmodule