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
    output wire                  dv_o,
    output wire [COLORDEPTH-1:0] buff_o [BUF_DEPTH-1:0]
    
);

reg [10:0] addr;
reg dv_ff1;


always @(posedge clk) begin
    if (rst || line_end) begin
        addr <= 0;
        dv_ff1 <= 0;
    end else begin
        addr <= addr + 1;
        dv_ff1 <= dv_i;
    end
end

//**************************
//*                        *
//**************************
reg [COLORDEPTH-1:0] dout_0;
always @ (posedge clk)
    dout_0 <= data_i;

assign buff_o[0] = dout_0;
assign dv_o = dv_ff1;
assign en = 1'b1;
assign we = dv_ff1;

//**************************
//*                        *
//**************************
genvar k;
generate
    for (k = 1; k < BUF_DEPTH; k = k + 1) begin
        wire [COLORDEPTH-1:0] din_k;
        reg  [COLORDEPTH-1:0] memory_k [SCREENWIDTH-1:0];
        reg  [COLORDEPTH-1:0] dout_k;

        assign din_k = buff_o[(k-1)];

        //sync dualp memory line n-1
        always @ (posedge clk)
            if (en)
                if(we)
                    memory_k[addr-1'b1] <= din_k;
                dout_k <= memory_k[addr];

        assign buff_o[k] = dout_k;
    end
endgenerate


endmodule