SRC_DIR = src
TB_DIR = tb

VHDL_SRC = $(SRC_DIR)/comps.vhd
TB_SRC = $(TB_DIR)/comps_tb.vhd
SIM_TOP = comps_tb
WAVE_FILE = wave.ghw

GHDL = ghdl
GTK_WAVE = gtkwave

FLAGS = --std=08 -fsynopsys 

all: run view

compile:
	$(GHDL) -a $(FLAGS) $(VHDL_SRC)
	$(GHDL) -a $(FLAGS) $(TB_SRC)
	$(GHDL) -e $(FLAGS) $(SIM_TOP)

run: compile
	$(GHDL) -r $(FLAGS) $(SIM_TOP) --wave=$(WAVE_FILE)

view: run
	$(GTK_WAVE) $(WAVE_FILE)

clean:
	rm -f *.o *.cf $(WAVE_FILE)

.PHONY: all compile run view clean