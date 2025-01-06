# FIT_PM_GW_CPLD

## Simulation
Modules simulated using `GHDL`.
Use `make <testbench>` to run simulatoin and to view the results in `gtkwave`. Available testbenches:
* cnt2_tb
* mux_latch_tb
* ampl_logic_tb
* ampl_top_tb

## `cnt2` module description
Output signals are clock-type signals with frequency(clk)/2 and frequency(clk)/4. Which are:
* 40MHz signal for gate circuit for strobe signal which comes out from CFD (Constant fraction discriminator)
* 20MHz signal as a trigger for integrators
![cnt2_tb_wave](img/cnt2_tb_wave.png "cnt2_tb_wave")\

## `mux_latch` module description
Output value is switched between two input values which are outputs of two integrators. `dly_6` signal is a strobe singal delayed by 6 clk cycles due to ADC pipeline delay. `cnt(1)` is a 20MHz trigger signal for integrators.
`in_a` is propagated to output in case strobe signal comes when `cnt(1)` is low and `in_b` when high.
![mux_latch_tb_wave](img/mux_latch_tb_wave.png "mux_latch_tb_wave")

## `ampl_logic` module description
![gate_strobe_circuit](img/gate_strobe_circuit.png "gate_strobe_circuit")\
![strobe_signal_reaction](img/strobe_signal_reaction.png "strobe_signal_reaction")\
![ampl_logic_tb_wave](img/ampl_logic_tb_wave.png "ampl_logic_tb_wave")

