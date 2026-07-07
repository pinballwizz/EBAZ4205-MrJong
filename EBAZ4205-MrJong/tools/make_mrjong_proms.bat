copy /b mj00 + mj01 + mj02 + mj03 cpu_rom.bin
make_vhdl_prom cpu_rom.bin cpu_rom.vhd

make_vhdl_prom mj20 gfx_rom1.vhd
make_vhdl_prom mj21 gfx_rom2.vhd

make_vhdl_prom mj61 palette.vhd
make_vhdl_prom mj60 color_lut.vhd

pause


