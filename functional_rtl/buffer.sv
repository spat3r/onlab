module buffer #(
    parameter COLORDEPTH = 8,
    parameter SCREENWIDTH = 1600,
    parameter LINE_END = 2048
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
    output wire [COLORDEPTH-1:0] px_line_n2_o,
    output wire [COLORDEPTH-1:0] px_line_n1_o,
    output wire [COLORDEPTH-1:0] px_line_n0_o
    
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
assign px_line_n0_o = data_i;
assign dv_o = dv_ff1;
// assign hs_o = hs_ff1;
// assign vs_o = vs_ff1;


//**************************
//*                        *
//**************************
wire [COLORDEPTH-1:0] din1;
reg  [COLORDEPTH-1:0] memory1 [SCREENWIDTH-1:0];
wire [COLORDEPTH-1:0] dout1;

assign din1 = data_i;

//async dualp memory line n-1
always @ (posedge clk)
    if (en)
        if(we)
            memory1[addr] <= din1;

assign dout1 = memory1[addr];
assign px_line_n1_o = dout1;

//**************************
//*                        *
//**************************
wire [COLORDEPTH-1:0] din2;
reg  [COLORDEPTH-1:0] memory2 [SCREENWIDTH-1:0];
reg  [COLORDEPTH-1:0] dout2;

assign din2 = dout1;

//async dualp memory line n-2
always @ (posedge clk)
    if (en)
        if(we)
            memory2[addr] <= din2;


assign dout2 = memory2[addr];
assign px_line_n2_o = dout2;

endmodule