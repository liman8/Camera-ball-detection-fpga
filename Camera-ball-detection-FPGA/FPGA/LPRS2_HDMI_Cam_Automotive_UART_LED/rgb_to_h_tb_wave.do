onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Verification}
add wave -noupdate /rgb_to_h_tb/rr
add wave -noupdate /rgb_to_h_tb/gg
add wave -noupdate /rgb_to_h_tb/gg
add wave -noupdate /rgb_to_h_tb/exp_h
add wave -noupdate /rgb_to_h_tb/obs_h
add wave -noupdate -divider {TB}
add wave -noupdate /rgb_to_h_tb/i_clk
add wave -noupdate /rgb_to_h_tb/in_rst
add wave -noupdate -radix decimal /rgb_to_h_tb/i_r
add wave -noupdate -radix decimal /rgb_to_h_tb/i_g
add wave -noupdate -radix decimal /rgb_to_h_tb/i_b
add wave -noupdate -radix decimal /rgb_to_h_tb/o_h
add wave -noupdate -divider {UUT Arrays}
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
