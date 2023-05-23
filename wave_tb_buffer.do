onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_buffer/uut/COLORDEPTH
add wave -noupdate -radix unsigned /tb_buffer/uut/SCREENWIDTH
add wave -noupdate -radix unsigned /tb_buffer/uut/LINE_END
add wave -noupdate -radix unsigned /tb_buffer/uut/BUF_DEPTH
add wave -noupdate -radix unsigned /tb_buffer/uut/clk
add wave -noupdate -radix unsigned /tb_buffer/uut/rst
add wave -noupdate -radix unsigned /tb_buffer/uut/data_i
add wave -noupdate -radix unsigned /tb_buffer/uut/line_end
add wave -noupdate -radix unsigned /tb_buffer/uut/dv_i
add wave -noupdate -radix unsigned /tb_buffer/uut/hs_i
add wave -noupdate -radix unsigned /tb_buffer/uut/vs_i
add wave -noupdate -radix unsigned /tb_buffer/uut/dv_o
add wave -noupdate -radix unsigned /tb_buffer/uut/hs_o
add wave -noupdate -radix unsigned /tb_buffer/uut/vs_o
add wave -noupdate -radix unsigned -childformat {{{/tb_buffer/uut/buff_o[4]} -radix unsigned} {{/tb_buffer/uut/buff_o[3]} -radix unsigned} {{/tb_buffer/uut/buff_o[2]} -radix unsigned} {{/tb_buffer/uut/buff_o[1]} -radix unsigned} {{/tb_buffer/uut/buff_o[0]} -radix unsigned}} -expand -subitemconfig {{/tb_buffer/uut/buff_o[4]} {-radix unsigned} {/tb_buffer/uut/buff_o[3]} {-radix unsigned} {/tb_buffer/uut/buff_o[2]} {-height 15 -radix unsigned} {/tb_buffer/uut/buff_o[1]} {-height 15 -radix unsigned} {/tb_buffer/uut/buff_o[0]} {-height 15 -radix unsigned}} /tb_buffer/uut/buff_o
add wave -noupdate -radix unsigned /tb_buffer/uut/addr
add wave -noupdate -radix unsigned /tb_buffer/uut/en
add wave -noupdate -radix unsigned /tb_buffer/uut/we
add wave -noupdate -radix unsigned -childformat {{{/tb_buffer/uut/genblk1[2]/memory_k[24]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[23]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[22]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[21]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[20]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[19]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[18]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[17]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[16]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[15]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[14]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[13]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[12]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[11]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[10]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[9]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[8]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[7]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[6]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[5]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[4]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[3]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[2]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[1]} -radix unsigned} {{/tb_buffer/uut/genblk1[2]/memory_k[0]} -radix unsigned}} -subitemconfig {{/tb_buffer/uut/genblk1[2]/memory_k[24]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[23]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[22]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[21]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[20]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[19]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[18]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[17]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[16]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[15]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[14]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[13]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[12]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[11]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[10]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[9]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[8]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[7]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[6]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[5]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[4]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[3]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[2]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[1]} {-height 15 -radix unsigned} {/tb_buffer/uut/genblk1[2]/memory_k[0]} {-height 15 -radix unsigned}} {/tb_buffer/uut/genblk1[2]/memory_k}
add wave -noupdate -radix unsigned {/tb_buffer/uut/genblk1[1]/memory_k}
add wave -noupdate -radix unsigned {/tb_buffer/uut/genblk1[2]/din_k}
add wave -noupdate -radix unsigned {/tb_buffer/uut/genblk1[1]/din_k}
add wave -noupdate -radix unsigned /tb_buffer/COLORDEPTH
add wave -noupdate -radix unsigned /tb_buffer/SCREENWIDTH
add wave -noupdate -radix unsigned /tb_buffer/BUF_DEPTH
add wave -noupdate -radix unsigned /tb_buffer/cntr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8324689 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {4540 ns} {25540 ns}
