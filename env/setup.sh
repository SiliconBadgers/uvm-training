# File:        setup.sh
# Author:      Isaac Hagedorn
# Date:        2026-10-08
# Description: Simulator setup on CAE Linux. Source it: `source env/setup.sh [questa] [xcelium] [vcs]`.
#              Always activates the Verilator 5.052 conda env (created on first use); each argument also loads that simulator's module.

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  echo "source this file: source ${0} [questa] [xcelium] [vcs]"
  exit 1
fi

_sb_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SB_UVM_ENV=${SB_UVM_ENV:-$HOME/.conda/envs/sb-uvm}

module load conda-forge/26.3.2 || return 1
if [ ! -x "$SB_UVM_ENV/bin/verilator" ]; then
  echo "[setup] creating $SB_UVM_ENV (first time only: about 2 GB and a few minutes)"
  # -p: without it mamba tries the read-only system env directory
  mamba env create -y -p "$SB_UVM_ENV" -f "$_sb_dir/environment.yml" || return 1
fi
conda activate "$SB_UVM_ENV" || return 1

for _sb_sim in "$@"; do
  case $_sb_sim in
    questa)  module load mentor/suite/2026 ;;
    # the default xcelium (2603) is newer than the campus license
    xcelium) module load cadence/xcelium/2509 ;;
    vcs)     module load synopsys/vcs-mx/2026.03 ;;
    *)       echo "[setup] unknown simulator '$_sb_sim' (use questa, xcelium or vcs)" ;;
  esac
done

# mentor/suite puts a Calibre python3 wrapper first on PATH, which breaks the course scripts;
# keep the conda env (python3, verilator) in front. The Makefiles drop it again for the simulator containers.
export PATH="$SB_UVM_ENV/bin:$PATH"

echo "[setup] ready: verilator $(verilator --version | awk '{print $2}')$(for _sb_t in vsim xrun vcs; do command -v $_sb_t >/dev/null && printf ', %s' $_sb_t; done)"
unset _sb_dir _sb_sim _sb_t
