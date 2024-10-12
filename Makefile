SRC_DIR = src
TB_DIR = tb

# VHDL_SRC = $(SRC_DIR)/cnt2.vhd
# TB_SRC = $(TB_DIR)/cnt2_tb.vhd
# SIM_TOP = cnt2_tb

VHDL_SRC_CNT2 = $(SRC_DIR)/cnt2.vhd
TB_SRC_CNT2 = $(TB_DIR)/cnt2_tb.vhd
SIM_TOP_CNT2 = cnt2_tb

VHDL_SRC_MUX_LATCH = $(SRC_DIR)/mux_latch.vhd
TB_SRC_MUX_LATCH = $(TB_DIR)/mux_latch_tb.vhd
SIM_TOP_MUX_LATCH = mux_latch_tb

WAVE_FILE = wave.ghw

GHDL = ghdl
GTK_WAVE = gtkwave

FLAGS = --std=08 -fsynopsys 

cnt2_tb: clean run_cnt2 view

mux_latch_tb: clean run_mux_latch viev

all: run_cnt2 view

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

view:
	$(GTK_WAVE) $(WAVE_FILE)

clean:
	rm -f *.o *.cf $(WAVE_FILE)

.PHONY: all compile run view clean