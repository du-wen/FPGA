quit -sim
.main clear

vlib work
vmap work work

vlog ./tb_spi.v
vlog ./../design/spi_ctrl.v
vlog ./../quartus_prj/ipcore_dir/ram_16_32_sr.v
vlog ./altera_lib/*.v

vsim -voptargs=+acc work.tb_spi

add wave tb_spi/spi_ctrl_inst/*
add wave tb_spi/rec_spi/*
run 300us
