module buffer #(
    parameter COLORDEPTH = 8,
    parameter SCREENWIDTH = 1600,
    parameter LINE_END = 2048,
    parameter BUF_DEPTH = 3
) (
    input  logic                  clk,
    input  logic                  rst,
    input  logic [COLORDEPTH-1:0] data_i,
    input  logic                  line_end,
    input  logic                  dv_i,
    output logic                  dv_o,
    output logic [COLORDEPTH-1:0] buff_o [BUF_DEPTH-1:0]
    
);

logic [10:0] addr;

always @(posedge clk) begin
    if (rst) begin
        addr <= 0;
        dv_ff1 <= 0;
    end else begin
        if (dv_i & ~line_end) addr <= addr + 1;
        else                  addr <= 0;
        dv_o <= dv_i;
    end
end

//**************************
//*                        *
//**************************
always @ (posedge clk) buff_o[0] <= data_i;

assign dv_o = dv_ff1;
assign en = 1'b1;
assign we = dv_ff1;

//**************************
//*                        *
//**************************
genvar k;
generate
    for (k = 1; k < BUF_DEPTH; k = k + 1) begin
        logic [COLORDEPTH-1:0] din_k;
        logic [COLORDEPTH-1:0] memory_k [SCREENWIDTH-1:0];
        logic [COLORDEPTH-1:0] dout_k;

        assign din_k = buff_o[(k-1)];

        //sync dualp memory line n-1
        always @ (posedge clk) begin
            if (en) begin
                if (we) memory_k[addr-1'b1] <= din_k;
                buff_o[k] <= memory_k[addr];
            end
        end
    end
endgenerate


endmodule