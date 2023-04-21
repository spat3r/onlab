//******************************************************************************
//* HDMI adó teszt alkalmazás. *
//******************************************************************************
module hdmi_tx(
    //Órajel és reset.
    input wire clk100M, //100 MHz órajel bemenet.
    input wire rstbt, //Reset bemenet (RST gomb).

    //A HDMI kimeneti csatlakozó jelei.
    output wire hdmi_tx_d0_p, //TMDS adat 0.
    output wire hdmi_tx_d0_n,
    output wire hdmi_tx_d1_p, //TMDS adat 1.
    output wire hdmi_tx_d1_n,
    output wire hdmi_tx_d2_p, //TMDS adat 2.
    output wire hdmi_tx_d2_n,
    output wire hdmi_tx_clk_p, //TMDS pixel órajel.
    output wire hdmi_tx_clk_n,

    input wire hdmi_tx_cec, //HDMI CEC (nem használt).
    input wire hdmi_tx_hpdn, //HDMI hot-plug érzékelés (nem használt).
    input wire hdmi_tx_scl, //EDID EEPROM I2C interfész (nem használt).
    input wire hdmi_tx_sda
);


//******************************************************************************
//* MMCM példányosítása a szükséges órajelek előállításához: *
//* - clk : 106,47 MHz pixel órajel *
//* - clk_5x: 532,35 MHz órajel a soros adatok kiléptetéséhez *
//******************************************************************************
wire mmcm_clkout0, mmcm_clkout1, mmcm_clkfb, mmcm_locked;
MMCME2_ADV #(
        .BANDWIDTH ("OPTIMIZED"),
        .CLKOUT4_CASCADE ("FALSE"),
        .COMPENSATION ("ZHOLD"),
        .STARTUP_WAIT ("FALSE"),
        .DIVCLK_DIVIDE (6), //A globális osztás értéke.
        .CLKFBOUT_MULT_F (63.875), //A globális szorzás értéke.
        .CLKFBOUT_PHASE (0.000),
        .CLKFBOUT_USE_FINE_PS("FALSE"),
        .CLKOUT0_DIVIDE_F (2.0), //A CLKOUT0 kimenetre beállított osztás.
        .CLKOUT0_PHASE (0.000),
        .CLKOUT0_DUTY_CYCLE (0.500),
        .CLKOUT0_USE_FINE_PS ("FALSE"),
        .CLKOUT1_DIVIDE (10), //A CLKOUT1 kimenetre beállított osztás.
        .CLKOUT1_PHASE (0.000),
        .CLKOUT1_DUTY_CYCLE (0.500),
        .CLKOUT1_USE_FINE_PS ("FALSE"),
        .CLKIN1_PERIOD (10.000) //Bemeneti órajel periódusidő [ns].
    ) mmcm_adv_inst (
        //Kimenő órajelek.
        .CLKFBOUT (mmcm_clkfb),
        .CLKOUT0 (mmcm_clkout0),
        .CLKOUT1 (mmcm_clkout1),
        //Bemenő órajelek.
        .CLKFBIN (mmcm_clkfb),
        .CLKIN1 (clk100M),
        .CLKIN2 (1'b0),
        //Az órajel bemenet kiválasztó jele (a CLKIN1 bemenetet használjuk).
        .CLKINSEL (1'b1),
        //A dinamikos átkonfiguráláshoz tartozó jelek.
        .DADDR (7'h0),
        .DCLK (1'b0),
        .DEN (1'b0),
        .DI (16'h0),
        .DO (),
        .DRDY (),
        .DWE (1'b0),
        //A dinamikos fázis léptetéshez tartozó jelek.
        .PSCLK (1'b0),
        .PSEN (1'b0),
        .PSINCDEC (1'b0),
        .PSDONE (),
        //Egyéb vezérlő és státusz jelek.
        .LOCKED (mmcm_locked),
        .PWRDWN (1'b0),
        .RST (rstbt)
    );

//Órajel bufferek.
wire clk, clk_5x;
BUFG BUFG_fastclk(.I(mmcm_clkout0), .O(clk_5x));
BUFG BUFG_slowclk(.I(mmcm_clkout1), .O(clk));

//Reset jel.
wire rst = ~mmcm_locked;


//******************************************************************************
//* 1440 x 900 @ 60 Hz VGA időzítés generátor. *
//******************************************************************************
wire [10:0] h_cnt;
wire [9:0] v_cnt;
wire h_sync, v_sync, blank;

vga_timing vga_timing(
    //Órajel és reset.
    .clk(clk), //Pixel órajel bemenet.
    .rst(rst), //Reset bemenet.

    //Az aktuális pixel pozíció.
    .h_cnt(h_cnt), //X-koordináta.
    .v_cnt(v_cnt), //Y-koordináta.

    //Szinkron és kioltó jelek.
    .h_sync(h_sync), //Horizontális szinkron pulzus.
    .v_sync(v_sync), //Vertikális szinkron pulzus.
    .blank(blank) //Kioltó jel.
    );

//A megjelenítendő minta előállítása.
wire [7:0] red = {8{h_cnt[6] ^ v_cnt[6]}};
wire [7:0] green = {8{h_cnt[7] ^ v_cnt[7]}};
wire [7:0] blue = {8{h_cnt[8] ^ v_cnt[8]}};


//******************************************************************************
//* TMDS adó. *
//******************************************************************************
tmds_transmitter tmds_transmitter(
    //Órajel és reset.
    .clk(clk), //Pixel órajel bemenet.
    .clk_5x(clk_5x), //5x pixel órajel bemenet.
    .rst(rst), //Reset jel.

    //Bemeneti video adatok.
    .red_in(red), //Piros színkomponens.
    .green_in(green), //Zöld színkomponens.
    .blue_in(blue), //Kék színkomponens.
    .blank_in(blank), //A nem látható képtartomány jelzése.
    .hsync_in(h_sync), //Horizontális szinkronjel.
    .vsync_in(v_sync), //Vertikális szinkronjel.

    //Kimenő TMDS jelek.
    .tmds_data0_out_p(hdmi_tx_d0_p), //Adat 0.
    .tmds_data0_out_n(hdmi_tx_d0_n),
    .tmds_data1_out_p(hdmi_tx_d1_p), //Adat 1.
    .tmds_data1_out_n(hdmi_tx_d1_n),
    .tmds_data2_out_p(hdmi_tx_d2_p), //Adat 2.
    .tmds_data2_out_n(hdmi_tx_d2_n),
    .tmds_clock_out_p(hdmi_tx_clk_p), //Pixel órajel.
    .tmds_clock_out_n(hdmi_tx_clk_n)
    );

endmodule