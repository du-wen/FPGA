quit -sim
.main clear

vlib work

vlog    ./tb_multi.v
vlog    ./../design/*.v
vlog    ./../quartus_prj/ipcore_dir/multi_16_16_l1.v
vlog    ./../quartus_prj/ipcore_dir/divider_16d8_l3.v
vlog    ./altera_lib/*.v

vsim  -voptargs=+acc    work.tb_multi

add wave    tb_multi/multi_inst/*

run 10us