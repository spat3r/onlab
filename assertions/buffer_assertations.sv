module sobel_top_assertions (
    input  logic                  clk,
    input  logic                  rst,
    input  logic [COLORDEPTH-1:0] data_i,
    input  logic                  line_end_i,
    input  logic                  dv_i,
    input  logic                  hs_i,
    input  logic                  vs_i,
    input  logic                  dv_o,
    input  logic                  hs_o,
    input  logic                  vs_o,
    input  logic [COLORDEPTH-1:0] buff_o [BUF_DEPTH-1:0]
    
);

endmodule