#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Author: Simone Machetti
# SPDX-License-Identifier: Apache-2.0
# -----------------------------------------------------------------------------

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENDOR="${REPO}/vendor"
ASAP7="${VENDOR}/asap7"
ASU="${VENDOR}/asap7sc7p5t_27"

UNPACK_LIBS="*_RVT_TT_nldm_*.lib.gz"
OA_MODEL="asap7sc7p5t_OA_RVT_TT_201020.v"

cd "${VENDOR}"
for name in asap7 asap7sc7p5t_27; do
    if [ ! -d "${VENDOR}/${name}" ]; then
        python3 vendor.py "${name}.vendor.hjson"
    fi
done

for gz in "${ASAP7}"/lib/NLDM/${UNPACK_LIBS}; do
    lib="${gz%.gz}"
    if [ ! -f "${lib}" ] || ! gunzip -c "${gz}" | cmp -s - "${lib}"; then
        gunzip -c "${gz}" > "${lib}"
    fi
done

if ! cmp -s "${ASU}/Verilog/${OA_MODEL}" "${ASAP7}/verilog/stdcell/${OA_MODEL}"; then
    cp -p "${ASU}/Verilog/${OA_MODEL}" "${ASAP7}/verilog/stdcell/${OA_MODEL}"
fi

echo "ready: ${ASAP7}"
