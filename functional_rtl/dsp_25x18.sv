`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:00:33 11/06/2014 
// Design Name: 
// Module Name:    dsp_block 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dsp_25x18
#(
   parameter A_REG = 2,
   parameter B_REG = 2
)(
   input  logic               clk,
   input  logic signed [24:0] a,
   input  logic signed [17:0] b,
   input  logic signed [47:0] pci, 
   output logic signed [47:0] p
);

    logic signed [24:0] a_reg[A_REG-1:0];
    logic signed [17:0] b_reg[B_REG-1:0];
    logic signed [42:0] m_reg;
    logic signed [47:0] p_reg;
    integer i;

    always @ (posedge clk) begin
        for (i=0; i<A_REG; i=i+1)
            a_reg[i] <= (i==0) ? a : a_reg[i-1];
    end

    always @ (posedge clk) begin
        for (i=0; i<B_REG; i=i+1)
            b_reg[i] <= (i==0) ? b : b_reg[i-1];
    end

    always @ (posedge clk) begin
        m_reg <= a_reg[A_REG-1]*b_reg[B_REG-1];
        p_reg <= m_reg + pci;
    end

    assign p = p_reg;

endmodule
