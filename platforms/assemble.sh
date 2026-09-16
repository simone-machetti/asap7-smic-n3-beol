#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Author: Simone Machetti
# -----------------------------------------------------------------------------

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENDOR="${REPO}/vendor"
PLATFORMS="${REPO}/platforms"
OVERLAYS="${PLATFORMS}/overlays"
SHARED="${PLATFORMS}/shared"

OA_MODELS="${VENDOR}/asap7sc7p5t_27/Verilog"
UNPACK_LIBS="*_RVT_TT_nldm_*.lib.gz"

unpack_libs() {
    local gz lib
    mkdir -p "${SHARED}/asap7/lib/NLDM"
    for gz in "${VENDOR}"/asap7/lib/NLDM/${UNPACK_LIBS}; do
        lib="${SHARED}/asap7/lib/NLDM/$(basename "${gz%.gz}")"
        if [ ! -f "${lib}" ] || [ "${gz}" -nt "${lib}" ]; then
            gunzip -c "${gz}" > "${lib}"
        fi
    done
}

link_tree() {
    local src="$1" dst="$2" keep_existing="$3"
    local file rel target
    while IFS= read -r -d '' file; do
        rel="${file#"${src}"/}"
        target="${dst}/${rel}"
        if [ -e "${target}" ] && [ "${keep_existing}" = 1 ]; then
            continue
        fi
        mkdir -p "$(dirname "${target}")"
        ln -sfn "$(realpath --relative-to="$(dirname "${target}")" "${file}")" "${target}"
    done < <(find "${src}" -type f -print0 | sort -z)
}

unpack_libs

platforms="asap7"
for overlay in "${OVERLAYS}"/*/; do
    platforms="${platforms} $(basename "${overlay}")"
done

for name in ${platforms}; do
    platform="${PLATFORMS}/${name}"
    rm -rf "${platform}"
    link_tree "${VENDOR}/asap7" "${platform}" 0
    link_tree "${SHARED}/asap7" "${platform}" 0
    link_tree "${OA_MODELS}" "${platform}/verilog/stdcell" 1
    if [ -d "${OVERLAYS}/${name}" ]; then
        link_tree "${OVERLAYS}/${name}" "${platform}" 0
    fi
    echo "assembled ${platform}"
done
