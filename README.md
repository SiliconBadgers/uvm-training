# uvm-training

The SiliconBadgers UVM course. Start here.

## Course path

| Step | Where | What you do |
|---|---|---|
| 0 | [Setup](#setup) below | Tools working; `make check` passes |
| 1 | `examples/adder` ([uvm-adder](https://github.com/ihagedo/uvm-adder)) | Read and run the smallest complete UVM testbench, then the exercises |
| 2 | `examples/uart` ([uvm-uart](https://github.com/ihagedo/uvm-uart)) | Read and run an agent with a config object and a serial protocol, then the exercises |
| 3 | [uvm-onboarding](https://github.com/ihagedo/uvm-onboarding) | On your own branch: write test plans and testbenches for designs you have not seen, from their specs, and find their bugs |

Steps 1 and 2 are worked examples: complete testbenches to read, run and modify. Step 3 is where you build your own.

## Setup

You need SSH access to the `ihagedo` repositories.

```bash
git clone --recurse-submodules git@github.com:ihagedo/uvm-training.git
cd uvm-training
source env/setup.sh            # Verilator 5.052 (default); creates the conda env on first use
source env/setup.sh questa     # also Questa; or xcelium, vcs, or several
make check                     # every example on Verilator
make check SIM=questa          # or on another simulator
```

`env/setup.sh` activates the Verilator conda env (`~/.conda/envs/sb-uvm`, about 2 GB, built from `env/environment.yml`) and loads the CAE module for each simulator you name.

| `SIM=` | Simulator | Module | Notes |
|---|---|---|---|
| `verilator` (default) | Verilator 5.052 | conda env | 2-state; each build takes about 1.5 min and 300–700 MB |
| `questa` | Questa 2025.1 | `mentor/suite/2026` | Runs inside `mentor-run`; `make gui` opens the GUI |
| `xcelium` | Xcelium 25.09 | `cadence/xcelium/2509` | The default `cadence/xcelium` (2603) is newer than the campus license |
| `vcs` | VCS 2026.03 | `synopsys/vcs-mx/2026.03` | Runs inside `synopsys-run`, 64-bit |

Every simulator compiles the same UVM 1.2 source (`UVM_Library/src`, with `UVM_NO_DPI`).

## Running an example

Every example takes the same knobs:

```bash
cd examples/uart
make run [SIM=questa] [TEST=<test>] [SEED=<n>] [VERB=UVM_HIGH]
make waves                     # FST on Verilator (gtkwave), VCD elsewhere
make gui SIM=questa            # Questa GUI with waves
make clean
```

## Layout

| Path | Repository | Contents |
|---|---|---|
| `examples/adder` | `ihagedo/uvm-adder` | Worked example 1 |
| `examples/uart` | `ihagedo/uvm-uart` | Worked example 2 |
| `UVM_Library` | `ihagedo/UVM_Library` | Accellera UVM 1.2: source, `UVM_Reference.html`, examples |
| `env/` | | Toolchain: conda env and `setup.sh` |
| `Makefile` | | `make check` / `make check-all` over every example |

## For maintainers

**Update an example:** commit and push in the example's repository, then in this one run `git submodule update --remote examples/<name>`, run `make check-all`, and commit the new submodule pointer.

**Add a worked example:**

1. Create `ihagedo/uvm-<name>`. Copy `examples/uart/Makefile` and adapt `TOP`, `INCS`, `SRCS` and `DEPS` so it takes the same knobs. Write a README with *Run it*, *Walkthrough* and *Exercises*. A `check-bug` target (see `examples/adder/Makefile`) lets `make check` confirm the testbench catches a seeded bug.
2. `git submodule add ../uvm-<name>.git examples/<name>` (relative URLs work over SSH and HTTPS).
3. `make check-all` with every simulator loaded, then commit.

## History

Until October 2026 this repository was the UART example itself, with the RTL from a CHIPKIT submodule. The UART testbench now lives in `ihagedo/uvm-uart` with the RTL copied in.
