module buffer #(
    parameter COLORDEPTH = 8,
    parameter SCREENWIDTH = 1600,
    parameter LINE_END = 2048,
    parameter BUF_DEPTH = 3
) (
    input  wire                  clk,
    input  wire                  rst,
    input  wire [COLORDEPTH-1:0] data_i,
    input  wire                  line_end,
    input  wire                  dv_i,
    // input  reg                   hs_i,
    // input  reg                   vs_i,
    output wire                  dv_o,
    // output reg                   hs_o,
    // output reg                   vs_o,
    output wire [BUF_DEPTH*COLORDEPTH-1:0] buff_o
    
);

reg [10:0] addr;
reg dv_ff1;
// reg hs_ff1;
// reg vs_ff1;
assign en = 1'b1;
assign we = dv_i;

always @(posedge clk) begin
    if (rst || line_end) begin
        addr <= 0;
        dv_ff1 <= 0;
        // hs_ff1 <= 0;
        // vs_ff1 <= 0;
    end else begin
        addr <= addr + 1;
        dv_ff1 <= dv_i;
        // hs_ff1 <= hs_i;
        // vs_ff1 <= vs_i;
    end
end

//**************************
//*                        *
//**************************
assign buff_o[COLORDEPTH-1:0] = data_i;
assign dv_o = dv_ff1;
// assign hs_o = hs_ff1;
// assign vs_o = vs_ff1;


//**************************
//*                        *
//**************************
genvar k;
generate
    for (k = 1; k < BUF_DEPTH; k = k + 1) begin
        wire [COLORDEPTH-1:0] din_k;
        reg  [COLORDEPTH-1:0] memory_k [SCREENWIDTH-1:0];
        wire [COLORDEPTH-1:0] dout_k;

        assign din_k = buff_o[k*COLORDEPTH-1:(k-1)*COLORDEPTH];

        //async dualp memory line n-1
        always @ (posedge clk)
            if (en)
                if(we)
                    memory_k[addr] <= din_k;

        assign dout_k = memory_k[addr];
        assign buff_o[(k+1)*COLORDEPTH-1:(k)*COLORDEPTH] = dout_k;
    end
endgenerate


endmodule