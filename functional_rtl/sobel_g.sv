module sobel_conv #(
    parameter COLORDEPTH = 8,

    parameter M_WIDTH = 3,
    parameter M_DEPTH = 3
    ) (
    input  logic                  clk,
    input  logic                  rst,
    input  logic [COLORDEPTH-1:0] vect_in [M_DEPTH-1:0],
    output logic [COLORDEPTH-1:0] conv_o,
    input  logic                  dv_i,
    input  logic                  hs_i,
    input  logic                  vs_i,
    output logic                  line_end_o,
    output logic                  hs_o,
    output logic                  vs_o,
    output logic                  dv_o
);

    // matrix elements
    logic signed [8:0] px_d [8:0];
    logic signed [8:0] px_q [8:0];
    //TODO: kideríteni hogy az signed shiftelésnél okosabb e az SV mint én xd
    // matrix row-sum
    logic signed [10:0] gx_d [2:0];
    logic signed [10:0] gy_d [2:0];
    // matrix column-sum
    logic signed [10:0] gx_q [2:0];
    logic signed [10:0] gy_q [2:0];
    // result
    logic signed [11:0] resx_d;
    logic signed [11:0] resy_d;
    logic signed [11:0] res_q;
    logic        [7:0]  conv_d;

    genvar k;
generate
    for (k = 0; k < M_DEPTH*M_WIDTH; k = k + 1) begin
        assign px_d[k] = ((k % M_DEPTH) == 0) ? {1'b0,vect_in[k/M_DEPTH]} : px_q[k-1];
        always_ff @( posedge clk ) px_q[k] <= px_d[k];
    end
endgenerate

    //
    //      | -1 0 1 |    |  px_r0_c0  px_r0_c-1  px_r0_c-2 |
    // Gx = | -2 0 2 | .* | px_r-1_c0 px_r-1_c-1 px_r-1_c-2 |
    //      | -1 0 1 |    | px_r-2_c0 px_r-2_c-1 px_r-2_c-2 |
    // this is equivalent to:  dot([]^T , px^T)
    //      |-1 -2 -1|    | px_r0_c0  px_r-1_c0  px_r-2_c0  |
    // Gx = | 0  0  0| .* | px_r0_c-1 px_r-1_c-1 px_r-2_c-1 |
    //      | 1  2  1|    | px_r0_c-2 px_r-1_c-2 px_r-2_c-2 |
    assign gx_d [0] = -((1*px_q[0]) + (2*px_q[3]) + (1*px_q[5]));
    assign gx_d [1] =      10'b0    +    10'b0    +    10'b0    ;
    assign gx_d [2] =   (1*px_q[2]) + (2*px_q[5]) + (1*px_q[8]) ;

    //      |-1 -2 -1|    | px_r 0_c0 px_r 0_c-1 px_r 0_c-2 |
    // Gy = | 0  0  0| .* | px_r-1_c0 px_r-1_c-1 px_r-1_c-2 |
    //      | 1  2  1|    | px_r-2_c0 px_r-2_c-1 px_r-2_c-2 |
    assign gy_d [0] = -((1*px_q[0]) + (2*px_q[1]) + (1*px_q[2]));
    assign gy_d [1] =      10'b0    +    10'b0    +    10'b0    ;
    assign gy_d [2] =   (1*px_q[6]) + (2*px_q[7]) + (1*px_q[8]) ;
    
    always_ff @(posedge clk) begin
        gx_q[0] <= gx_d[0];
        gx_q[1] <= gx_d[1];
        gx_q[2] <= gx_d[2];

        gy_q[0] <= gy_d[0];
        gy_q[1] <= gy_d[1];
        gy_q[2] <= gy_d[2];
    end

    assign resx_d =  gx_q[0] + gx_q[1] + gx_q[2];
    assign resy_d =  gy_q[0] + gy_q[1] + gy_q[2];

    // resx and resy is only two addition, g_q[1] is always zero
    // thus this can be implemented w/ 5 adders -> 6:3 compressor w/ dsp 
    always_ff @(posedge clk) res_q <= (resx_d>>1)+(resy_d>>1);

    always_comb begin : conv_sat
        // if abs(res_q)>FF -> saturation
        if (res_q[10:8]) conv_d <= 8'hFF;
        // if negative -> invert
        else if (res_q[11]) conv_d <= ~res_q[7:0] + 1'b1;
        else                conv_d <=  res_q[7:0];
    end

    always_ff @(posedge clk) conv_o <= conv_d;

    logic [2:0] dv_shr;
    logic [2:0] hs_shr;
    logic [2:0] vs_shr;
    wire  line_end_d = dv_shr[2] & ~dv_shr[1];


    always_ff @(posedge clk) begin
        if (rst) begin
            dv_shr <= 0; dv_o <= 0;
            hs_shr <= 0; hs_o <= 0;
            vs_shr <= 0; vs_o <= 0;
        end else begin
            dv_shr <= {dv_shr[1:0],dv_i};
            hs_shr <= {hs_shr[1:0],hs_i};
            vs_shr <= {vs_shr[1:0],vs_i};
            line_end_o <= line_end_d;
            dv_o <= dv_shr[2];
            hs_o <= hs_shr[2];
            vs_o <= vs_shr[2];
        end
    end

endmodule



