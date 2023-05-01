module vga_timing #(
        parameter H_VISIBLE        = 11'd1440,
        parameter H_FRONT_PORCH    = 11'd80,
        parameter H_SYNC_PULSE     = 11'd152,
        parameter H_BACK_PORCH     = 11'd232,
        parameter H_POLARITY       = 1'b1,
        parameter V_VISIBLE        = 10'd900,
        parameter V_FRONT_PORCH    = 10'd1,
        parameter V_SYNC_PULSE     = 10'd3,
        parameter V_BACK_PORCH     = 10'd28,
        parameter V_POLARITY       = 1'b1
    )(
        //Órajel és reset.
        input logic clk, //Pixel órajel bemenet.
        input logic rst, //Reset bemenet.

        //Az aktuális pixel pozíció.
        output logic [10:0] h_cnt = 11'd0, //X-koordináta.
        output logic [9:0] v_cnt = 10'd0, //Y-koordináta.

        //Szinkron és kioltó jelek.
        output logic h_sync = 1'b1, //Horizontális szinkron pulzus.
        output logic v_sync = 1'b0, //Vertikális szinkron pulzus.
        output logic blank //Kioltó jel.
    );

//******************************************************************************
//* Időzítési paraméterek.
//* 1440 x 900 @ 60 Hz VGA időzítés generátor. *
//******************************************************************************


localparam H_BLANK_BEGIN    = H_VISIBLE - 1;
localparam H_SYNC_BEGIN     = H_BLANK_BEGIN + H_FRONT_PORCH;
localparam H_SYNC_END       = H_SYNC_BEGIN + H_SYNC_PULSE;
localparam H_BLANK_END      = H_SYNC_END + H_BACK_PORCH;
localparam V_BLANK_BEGIN    = V_VISIBLE - 1;
localparam V_SYNC_BEGIN     = V_BLANK_BEGIN + V_FRONT_PORCH;
localparam V_SYNC_END       = V_SYNC_BEGIN + V_SYNC_PULSE;
localparam V_BLANK_END      = V_SYNC_END + V_BACK_PORCH;

//******************************************************************************
//* A horizontális és vertikális számlálók. *
//******************************************************************************

always_ff @(posedge clk) begin
    if (rst || (h_cnt == H_BLANK_END)) h_cnt <= 12'd0;
    else                               h_cnt <= h_cnt + 12'd1;
end

always_ff @(posedge clk) begin
    if (rst) v_cnt <= 11'd0;
    else if (h_cnt == H_BLANK_END) begin
        if (v_cnt == V_BLANK_END) v_cnt <= 11'd0;
        else                      v_cnt <= v_cnt + 11'd1;
    end
end

//******************************************************************************
//* A szinkron pulzusok generálása. *
//******************************************************************************

always_ff @(posedge clk) begin
    if (rst)                        h_sync <= ~H_POLARITY;
    else if (h_cnt == H_SYNC_BEGIN) h_sync <= H_POLARITY;
    else if (h_cnt == H_SYNC_END)   h_sync <= ~H_POLARITY;
end

always @(posedge clk)
begin
    if (rst) v_sync <= ~V_POLARITY;
    else if (h_cnt == H_BLANK_END) begin
            if (v_cnt == V_SYNC_BEGIN)    v_sync <=  V_POLARITY;
            else if (v_cnt == V_SYNC_END) v_sync <= ~V_POLARITY;
    end
end

//******************************************************************************
//* A kioltó jel előállítása. *
//******************************************************************************

logic h_blank = 1'b1;
logic v_blank = 1'b1;

always_ff @(posedge clk) begin
    if (rst)                         h_blank <= 1'b1;
    else if (h_cnt <= H_BLANK_BEGIN) h_blank <= 1'b0;
    else if (h_cnt <= H_BLANK_END)   h_blank <= 1'b1;
    else                             h_blank <= 1'b0;
end

always_ff @(posedge clk) begin
    if (rst) v_blank <= 1'b0;
    else if (h_cnt == H_BLANK_END) begin
        if (v_cnt == V_BLANK_BEGIN)    v_blank <= 1'b1;
        else if (v_cnt == V_BLANK_END) v_blank <= 1'b0;
    end
end
assign blank = h_blank | v_blank;
endmodule