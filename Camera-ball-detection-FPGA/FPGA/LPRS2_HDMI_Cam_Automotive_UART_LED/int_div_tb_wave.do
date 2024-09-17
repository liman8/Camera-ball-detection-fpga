onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Verification}
add wave -noupdate /int_div_tb/non_shifted_num
add wave -noupdate /int_div_tb/rr
add wave -noupdate /int_div_tb/gg
add wave -noupdate /int_div_tb/exp_h
add wave -noupdate /int_div_tb/obs_h
add wave -noupdate -divider {TB}
add wave -noupdate /int_div_tb/i_clk
add wave -noupdate /int_div_tb/in_rst
add wave -noupdate -radix decimal /int_div_tb/i_num
add wave -noupdate -radix unsigned /int_div_tb/i_den
add wave -noupdate -radix decimal /int_div_tb/o_res
add wave -noupdate -divider {UUT Arrays}
add wave -noupdate /int_div_tb/uut/a_neg
add wave -noupdate -radix unsigned /int_div_tb/uut/a_num2
add wave -noupdate -radix unsigned /int_div_tb/uut/a_den2
add wave -noupdate -radix unsigned /int_div_tb/uut/a_res
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1000000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 407
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2 us}
