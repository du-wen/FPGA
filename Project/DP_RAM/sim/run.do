quit -sim
.main clear

vlib work

vlog        ./tb_fifo.v
vlog        ./../design/*.v


vsim        -voptargs=+acc  work.tb_fifo

add wave    tb_fifo/fifo_inst/*

run 10us