module buffer #(
    parameter COLORDEPTH = 8,
    parameter SCREENWIDTH = 1600,
    parameter BUF_DEPTH = 3
) (
    input  logic                  clk,
    input  logic                  rst,
    input  logic [COLORDEPTH-1:0] data_i,
    input  logic                  line_end_i,
    input  logic                  dv_i,
    input  logic                  hs_i,
    input  logic                  vs_i,
    output logic                  dv_o,
    output logic                  hs_o,
    output logic                  vs_o,
    output logic [COLORDEPTH-1:0] buff_o [BUF_DEPTH-1:0]
    
);

logic [10:0] addr;

always @(posedge clk) begin
    if (rst) begin
        addr <= 0;
    end else begin
        if (dv_i) addr <= addr + 1;
        else      addr <= 0;
    end
end

//**************************
//*                        *
//**************************
always @ (posedge clk) buff_o[0] <= data_i;

assign en = dv_i | dv_o;
assign we = dv_o;

//**************************
//*                        *
//**************************
genvar k;
generate
    for (k = 1; k < BUF_DEPTH; k = k + 1) begin
        logic [COLORDEPTH-1:0] din_k;
        logic [COLORDEPTH-1:0] memory_k [SCREENWIDTH-1:0];

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


// TODO: the last row stays in the ram and it is transfered to the forst row of the next image

    always_ff @(posedge clk) begin
        if (rst) begin
            dv_o <= 0;
            hs_o <= 0;
            vs_o <= 0;
        end else begin
            dv_o <= dv_i;
            hs_o <= hs_i;
            vs_o <= vs_i;
        end
    end
endmodule