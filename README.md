# manos_cpu

Verilog RTL implementation of Mano's basic computer CPU (hardwired control unit,
external memory interface), taken through RTL-to-GDSII with LibreLane on sky130A.

## Layout
- `src/`: RTL
- `sim/testbenches/`: testbenches (compile with `iverilog -o <name>.vvp ...`, run with `vvp <name>.vvp`)
- `librelane/config.json`: LibreLane configuration
- `results/`: final GDS and metrics from the clean run
- `docs/sky130_gds3d.txt`: GDS3D process file for sky130

## Run the flow (IIC-OSIC-TOOLS)
    iic-pdk sky130A
    cd librelane
    librelane config.json

## View the layout in 3D
    GDS3D -p docs/sky130_gds3d.txt -i results/manos_cpu.gds
