# File:        Makefile
# Author:      Isaac Hagedorn
# Date:        2026-10-08
# Description: Runs every worked example: `make check [SIM=...]`, or on every simulator: `make check-all`.

# verilator | questa | xcelium | vcs
SIM      ?= verilator
# simulators for check-all
SIMS     ?= verilator questa xcelium vcs
EXAMPLES := $(patsubst examples/%/Makefile,%,$(wildcard examples/*/Makefile))

.PHONY: help check check-all clean

help:
	@echo "make check [SIM=verilator|questa|xcelium|vcs] | check-all [SIMS=...] | clean"
	@echo "examples: $(EXAMPLES)"

# Every example's default test must pass, and every example with a check-bug target must catch its seeded bug
check:
	@test -n "$(EXAMPLES)" || { echo "no examples: run git submodule update --init"; exit 1; }
	@fail=0; \
	for e in $(EXAMPLES); do \
	  $(MAKE) --no-print-directory -C examples/$$e run SIM=$(SIM) || fail=1; \
	  if grep -q '^check-bug:' examples/$$e/Makefile; then \
	    $(MAKE) --no-print-directory -C examples/$$e check-bug SIM=$(SIM) || fail=1; fi; \
	done; \
	exit $$fail

check-all:
	@fail=0; for s in $(SIMS); do echo "=== $$s"; $(MAKE) --no-print-directory check SIM=$$s || fail=1; done; exit $$fail

clean:
	@for e in $(EXAMPLES); do $(MAKE) --no-print-directory -C examples/$$e clean; done
