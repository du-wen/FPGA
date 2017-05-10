quit -sim
.main clear

vlib work

vlog        ./tb_RAM.v
vlog        ./../design/*.v

vsim        -voptargs=+acc  work.tb_RAM

add wave    tb_RAM/RAM_inst/*

run 10us