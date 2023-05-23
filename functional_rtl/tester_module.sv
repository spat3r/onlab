module regressionTester #(
    parameter VRES = 900,
    parameter HRES = 1600
) (
    input  logic        clk,
    input  logic        rst,
    input  logic        vga_dv_o,
    input  logic        vga_hs_o,
    input  logic        vga_vs_o,
    input  logic  [7:0] tb_red_o,
    input  logic  [7:0] tb_green_o,
    input  logic  [7:0] tb_blue_o,
    input  logic        tb_dv_o,
    input  logic        tb_hs_o,
    input  logic        tb_vs_o,
    output logic  [7:0] tb_red_i,
    output logic  [7:0] tb_green_i,
    output logic  [7:0] tb_blue_i,
    output logic        tb_dv_i,
    output logic        tb_hs_i,
    output logic        tb_vs_i,
    input  logic [10:0] h_cnt,
    input  logic [10:0] v_cnt
);


integer red_rd, green_rd, blue_rd, result_rd;
integer current_row_i, current_col_i;
integer current_row_o, current_col_o;
integer datain_pointer, dataout_pointer, csv_pointer;

initial begin
    datain_pointer = $fopen("pic_input.txt","r");
    if (!datain_pointer) $display("Couldn't open pic_input.txt");
    else $display("datain_pointer = %d", datain_pointer);


    @(posedge rst)
    @(negedge rst)

    for (longint j = 0; j < VRES ; j++) begin
        for (longint k = 0; k < HRES ; k++) begin

            //wait until next pixel
            @( h_cnt ) begin
                if ( tb_dv_i ) begin
                    $fscanf(datain_pointer,"[%d,%d]: red: %d, green: %d, blue: %d", current_col_i, current_row_i, red_rd, green_rd, blue_rd);
                    // TODO: assert col == hcnt
                    // TODO: assert row == vcnt
                    tb_red_i = red_rd[7:0];
                    tb_green_i = green_rd[7:0];
                    tb_blue_i = blue_rd[7:0];
                    // $fdisplay(dataout_pointer,"\t\t%d. coord_a: %f, coord_b: %f", currentCoord, coord_a_f, coord_b_f);
                // $display("\t\t%d. coord_a: %f, coord_b: %f", currentCoord, coord_a_f, coord_b_f);                    
                end
            end
        end
    end
    $fclose(datain_pointer);
    $stop;

end


initial begin

    @(posedge rst)
    @(negedge rst)

    dataout_pointer = $fopen("pic_output.txt","w");
    if (!dataout_pointer) $display("Couldn't open pic_output.txt");
    else $display("dataout_pointer = %b", dataout_pointer);

    csv_pointer = $fopen("csv.csv","w");
    if (!csv_pointer) $display("Couldn't open csv.csv");
    else $display("csv_pointer = %b", csv_pointer);
    
    $fdisplay(csv_pointer,"col;row;duv;py", current_col_o, current_row_o, tb_red_o, result_rd);


    for (longint j = 0; j < VRES ; j++) begin
        for (longint k = 0; k < HRES ; k++) begin

            //wait until next pixel
            @( h_cnt ) begin
                if ( tb_dv_i ) begin
                    $fscanf(dataout_pointer,"[%d,%d]: %d", current_col_o, current_row_o, result_rd);
                    // TODO: assert col == hcnt
                    // TODO: assert row == vcnt
                    
                    $fdisplay(csv_pointer,"%d;%d;%d;%d", current_col_o, current_row_o, tb_red_o, result_rd);
                    // TODO: assert (tb_red_o >> 1) == (result >> 1)
                end
            end
        end
    end

    $fclose(dataout_pointer);
    $stop;
end

endmodule
