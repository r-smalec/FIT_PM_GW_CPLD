SRC_DIR = src
TB_DIR = tb

TEST_DIR = test

VHDL_SRC_PULSE_DELAY = $(TEST_DIR)/pulse_delay.vhd
TB_SRC_PULSE_DELAY = $(TEST_DIR)/pulse_delay_tb.vhd
SIM_TOP_PULSE_DELAY = pulse_delay_tb

VHDL_SRC_CNT2 = $(SRC_DIR)/cnt2.vhd
TB_SRC_CNT2 = $(TB_DIR)/cnt2_tb.vhd
SIM_TOP_CNT2 = cnt2_tb

VHDL_SRC_MUX_LATCH = $(SRC_DIR)/mux_latch.vhd
TB_SRC_MUX_LATCH = $(TB_DIR)/mux_latch_tb.vhd
SIM_TOP_MUX_LATCH = mux_latch_tb

VHDL_SRC_AMPL_LOGIC = $(SRC_DIR)/cnt2.vhd $(SRC_DIR)/mux_latch.vhd $(SRC_DIR)/ampl_logic.vhd
TB_SRC_AMPL_LOGIC = $(TB_DIR)/ampl_logic_tb.vhd
SIM_TOP_AMPL_LOGIC = ampl_logic_tb

WAVE_FILE = wave.ghw

GHDL = ghdl
GTK_WAVE = gtkwave

FLAGS = --std=08 -fsynopsys 

pulse_delay_tb: clean run_pulse_delay view

cnt2_tb: clean run_cnt2 view

mux_latch_tb: clean run_mux_latch view

ampl_logic_tb: clean run_ampl_logic view

all: run_cnt2 view

compile_pulse_delay:
	$(GHDL) -a $(FLAGS) $(VHDL_SRC_PULSE_DELAY)
	$(GHDL) -a $(FLAGS) $(TB_SRC_PULSE_DELAY)
	$(GHDL) -e $(FLAGS) $(SIM_TOP_PULSE_DELAY)

run_pulse_delay: compile_pulse_delay
	$(GHDL) -r $(FLAGS) $(SIM_TOP_PULSE_DELAY) --wave=$(WAVE_FILE)

compile_cnt2:
	$(GHDL) -a $(FLAGS) $(VHDL_SRC_CNT2)
	$(GHDL) -a $(FLAGS) $(TB_SRC_CNT2)
	$(GHDL) -e $(FLAGS) $(SIM_TOP_CNT2)

run_cnt2: compile_cnt2
	$(GHDL) -r $(FLAGS) $(SIM_TOP_CNT2) --wave=$(WAVE_FILE)

compile_mux_latch:
	$(GHDL) -a $(FLAGS) $(VHDL_SRC_MUX_LATCH)
	$(GHDL) -a $(FLAGS) $(TB_SRC_MUX_LATCH)
	$(GHDL) -e $(FLAGS) $(SIM_TOP_MUX_LATCH)

run_mux_latch: compile_mux_latch
	$(GHDL) -r $(FLAGS) $(SIM_TOP_MUX_LATCH) --wave=$(WAVE_FILE)

compile_ampl_logic:
	$(GHDL) -a $(FLAGS) $(VHDL_SRC_AMPL_LOGIC)
	$(GHDL) -a $(FLAGS) $(TB_SRC_AMPL_LOGIC)
	$(GHDL) -e $(FLAGS) $(SIM_TOP_AMPL_LOGIC)

run_ampl_logic: compile_ampl_logic
	$(GHDL) -r $(FLAGS) $(SIM_TOP_AMPL_LOGIC) --wave=$(WAVE_FILE)

view:
	$(GTK_WAVE) $(WAVE_FILE)

clean:
	rm -f *.o *.cf $(WAVE_FILE) *.exe

.PHONY: all compile run view clean