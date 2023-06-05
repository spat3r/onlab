module rgb2y_assertions (
    input logic        clk,
    input logic        rst,
    input logic  [7:0] red_i,
    input logic  [7:0] green_i,
    input logic  [7:0] blue_i,
    input logic  [7:0] gamma_o,
    input logic        dv_i,
    input logic        hs_i,
    input logic        vs_i,
    input logic        dv_o,
    input logic        hs_o,
    input logic        vs_o,
    input logic        line_end_o
    
);
    
    property output_is_valid;
        @(posedge clk) disable iff (rst)
            dv_i |-> (gamma_o !=  8'bX) ;
    endproperty

    property definetly_wrong_prop;
        @(posedge clk) disable iff (rst)
            vs_o |-> (gamma_o ==  8'hF3) ;
    endproperty

    prop_o_valid: assert property (output_is_valid) else $display("Output wasn't valid!");
    prop_dummy: assert property (definetly_wrong_prop) else $display("Output wasn't valid!");

endmodule