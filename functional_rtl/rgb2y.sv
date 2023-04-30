module rgb2y #(
    parameter COLORDEPTH = 8,
    parameter POWEREFF = 2
    ) (
    input  logic       clk,
    input  logic       rst,
    input  logic[23:0] rgb_i,
    output logic[7:0]  gamma_o,
    input  logic       dv_i,
    input  logic       hs_i,
    input  logic       vs_i,
    output logic       dv_o,
    output logic       hs_o,
    output logic       vs_o,
    output logic       line_end_o
    );

    logic[7:0] r, g, b;
    logic[7:0] r_mul_d, g_mul_d, b_mul_d;
    logic[7:0] r_mul_q, g_mul_q, b_mul_q;

    assign r = dv_i ? rgb_i [23:16] : 8'b0;
    assign g = dv_i ? rgb_i [15:8]  : 8'b0;
    assign b = dv_i ? rgb_i [7:0]   : 8'b0;

    assign r_mul_d = (r >> 2) + (r >> 5);
    assign g_mul_d = (g >> 1) + (g >> 4);
    assign b_mul_d = (b >> 4) + (b >> 5); // + (b >> 6) + (b >> 7);
    
    always @(posedge clk ) begin
        if (rst) begin
            r_mul_q <= 0;
            g_mul_q <= 0;
            b_mul_q <= 0;
        end else begin
            r_mul_q <= r_mul_d;
            g_mul_q <= g_mul_d;
            b_mul_q <= b_mul_d;
        end
    end
    
    logic[7:0] gamma_d;
    assign gamma_d = (r_mul_q + g_mul_q + b_mul_q);
    //data route, no need for any reset
    always @(posedge clk ) begin
        gamma_o <= gamma_d;
    end

    logic [1:0] dv_shr;
    logic [1:0] hs_shr;
    logic [1:0] vs_shr;
    wire  line_end_d = dv_shr[0] & ~dv_i;

    always_ff @(posedge clk) begin
        if (rst) begin
            dv_shr <= 0;
            hs_shr <= 0;
            vs_shr <= 0;
        end else begin
            dv_shr <= {dv_shr[0],dv_i};
            hs_shr <= {hs_shr[0],hs_i};
            vs_shr <= {vs_shr[0],vs_i};
            line_end_o <= line_end_d;
            dv_o <= dv_shr[0];
            hs_o <= hs_shr[0];
            vs_o <= vs_shr[0];
        end
    end

endmodule



// rgb2 to gamma, double 6:3 compressor with dsp
module rgb2y_2 #(
    parameter COLORDEPTH = 8,
    parameter POWEREFF = 2
    ) (
    input  logic       clk,
    input  logic       rst,
    input  logic[23:0] rgb_i,
    output logic[7:0]  gamma_o,
    input  logic       dv_i,
    input  logic       hs_i,
    input  logic       vs_i,
    output logic       dv_o,
    output logic       hs_o,
    output logic       vs_o,
    output logic       line_end_o
    );

    logic[7:0] r, g, b;
    logic[7:0] rb_mul_d, g_mul_d;
    logic[7:0] rb_mul_q, g_mul_q;

    assign r = dv_i ? rgb_i [23:16] : 8'b0;
    assign g = dv_i ? rgb_i [15:8]  : 8'b0;
    assign b = dv_i ? rgb_i [7:0]   : 8'b0;

    //  osszesen 6 shiftelt osszeget kell osszeadni mindket esetben
    //  6:3-as kompresszorral szintetizalhato
    assign rb_mul_d = r*8'b00110110 + b*8'b00010010 ;
    assign g_mul_d =  g*8'b10110111;

    always_ff @(posedge clk ) begin
        if (rst) begin
            rb_mul_q <= 0;
            g_mul_q <= 0;
        end else begin
            rb_mul_q <= rb_mul_d;
            g_mul_q <= g_mul_d;
        end
    end

    logic[7:0] gamma_d;
    assign gamma_d = (rb_mul_q + g_mul_q);

    //data route, no need for any reset
    always @(posedge clk ) begin
        gamma_o <= gamma_d;
    end

    logic [1:0] dv_shr;
    logic [1:0] hs_shr;
    logic [1:0] vs_shr;
    wire  line_end_d = dv_shr[0] & ~dv_i;

    always_ff @(posedge clk) begin
        if (rst) begin
            dv_shr <= 0;
            hs_shr <= 0;
            vs_shr <= 0;
        end else begin
            dv_shr <= {dv_shr[0],dv_i};
            hs_shr <= {hs_shr[0],hs_i};
            vs_shr <= {vs_shr[0],vs_i};
            line_end_o <= line_end_d;
            dv_o <= dv_shr[0];
            hs_o <= hs_shr[0];
            vs_o <= vs_shr[0];
        end
    end

endmodule



// rgb2 to gamma, double dsp w/ fixed point 
module rgb2y_3 #(
    parameter COLORDEPTH = 8,
    parameter POWEREFF = 2
    ) (
    input  logic        clk,
    input  logic        rst,
    input  logic [23:0] rgb_i,
    output logic [7:0]  gamma_o,
    input  logic        dv_i,
    input  logic        hs_i,
    input  logic        vs_i,
    output logic        dv_o,
    output logic        hs_o,
    output logic        vs_o,
    output logic        line_end_o
    );

    logic[7:0] r, g, b;
    logic[7:0] g_reg[1:0];
    logic[7:0] b_reg;

    // rgb VEKTOR SZETVALASZTSA KOMPONENSEK SZERINT
    assign r = dv_i ? rgb_i [23:16] : 8'b0;
    assign g = dv_i ? rgb_i [15:8]  : 8'b0;
    assign b = dv_i ? rgb_i [7:0]   : 8'b0;

    // G ES B MENTESE A KESLELTETESEK MIATT
    always_ff @(posedge clk ) begin
        b_reg <= b;
        g_reg[0] <= g;
        g_reg[1] <= g_reg[0];
    end

    logic [47:0] po_gb, po_rg;

    dsp_25x18_presub #(.USE_PCI_REG(1)) dsp_25x18_rg(
        .clk(clk),
        .a({1'b0,r,16'b0}),
        .d({1'b0,g,21'b0}),
        //  KR = 0,2126 *2^17 = 27866
        .b(18'd27866),
        .pci({1'b0,g_reg[1],39'b0}), 
        .p(po_rg)
    );

    dsp_25x18_presub #(.USE_PCI_REG(0)) dsp_25x18_bg(
        .clk(clk),
        .a({1'b0,b_reg,16'b0}),
        .d({1'b0,g_reg[0],21'b0}),
        //  KB = -0,0722 *2^17 = 9463
        .b(-18'd9463),
        .pci(po_rg), 
        .p(po_gb)
    );

    logic [7:0] gamma_d;
    assign gamma_d = (po_gb[47]) ? 8'b0 : po_gb[46:39];

    always @(posedge clk ) begin
        gamma_o <= gamma_d;
    end

    logic [4:0] dv_shr;
    logic [4:0] hs_shr;
    logic [4:0] vs_shr;
    wire  line_end_d = dv_shr[4] & ~dv_shr[3];

    always_ff @(posedge clk) begin
        if (rst) begin
            dv_shr <= 0;
            hs_shr <= 0;
            vs_shr <= 0;
        end else begin
            dv_shr <= {dv_shr[3:0],dv_i};
            hs_shr <= {hs_shr[3:0],hs_i};
            vs_shr <= {vs_shr[3:0],vs_i};
            line_end_o <= line_end_d;
            dv_o <= dv_shr[4];
            hs_o <= hs_shr[4];
            vs_o <= vs_shr[4];
        end
    end

endmodule
