#!/bin/bash
set -exu
BINDGEN_EXTRA_CLANG_ARGS="-D__CUDA_BF16_TYPES_EXIST__" \
    bindgen \
    --allowlist-var="^CUDA_VERSION" \
    --allowlist-type="^nccl.*" \
    --allowlist-var="^nccl.*" \
    --allowlist-function="^nccl.*" \
    --default-enum-style=rust \
    --no-doc-comments \
    --with-derive-default \
    --with-derive-eq \
    --with-derive-hash \
    --with-derive-ord \
    --use-core \
    --dynamic-loading Lib \
    --no-layout-tests \
    wrapper.h -- -I$CUDA_INCLUDES -I/usr/lib/gcc/x86_64-linux-gnu/12/include/ \
    >tmp.rs

CUDA_VERSION=$(cat tmp.rs | grep "CUDA_VERSION" | awk '{ print $6 }' | sed 's/.$//')
mv tmp.rs sys_${CUDA_VERSION}.rs
