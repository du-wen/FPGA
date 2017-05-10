quit -sim
.main clear

vlib work

vlog        ./tb_fifo.v
vlog        ./../design/*.v
vlog        ./../quartus_prj/ipcore_dir/dp_ram_512_8_swsr.v
vlog        ./altera_lib/*.v

vsim        -voptargs=+acc  work.tb_fifo

add wave    tb_fifo/fifo_inst/*

run 20us