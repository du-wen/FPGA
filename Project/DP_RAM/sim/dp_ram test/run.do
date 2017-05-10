quit -sim
.main clear

vlib work

vlog        ./tb_dp_ram.v
vlog        ./../design/*.v


vsim        -voptargs=+acc  work.tb_dp_ram

add wave    tb_dp_ram/dp_ram_inst/*

run 10us