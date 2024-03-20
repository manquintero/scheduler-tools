#!/bin/bash

layers=(
  meta-intel
  meta-openembedded/meta-oe
  meta-scheduler
)

set_root_dir() {
  top_dir=""
  until [[ ${PWD} = "/" ]] || [[ -n "${top_dir}" ]]; do
    if [[ -d .repo ]]; then
      top_dir="${PWD}"
      break
    fi
    cd ..
  done

  if [[ -z "${top_dir}" ]]; then
    echo "::error: Unable to locate TOP_DIR"
    exit 1
  fi
  export TOP_DIR=${top_dir}
}

add_layers() {
  for layer in ${layers[@]}; do
    bitbake-layers add-layer "${TOP_DIR}/${layer}"
  done
}

build_image(){
  bitbake core-image-minimal
}

show_help(){
  declare -F | grep build_
}

# Main
set_root_dir
add_layers
show_help