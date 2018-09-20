#!/bin/bash 

set -eu

#LLVM_VER=-5.0
LLVM_VER=

UTILS="python3 clang tree htop git subversion vim emacs"
OPAM_DEPS="gcc make python2.7 m4 pkg-config unzip cmake"
OCAML_PKGS="ocaml opam"
OPAM_PKGS=

update_cmd() { apt update -y && apt upgrade -y ; }
install_cmd() { apt install -y "$@" ; }


report() { echo " = = = => [CAMERUPTITE]:" "$@" ; }
log_do() {
    local name=$1
    shift
    echo "--------"
    report "Starting:" "${name}" "..."
    "$@"
    report "Complete:" "${name}"
    echo "--------"
}

cd ~

log_do "update package manager" update_cmd

log_do "install some handy utilities" install_cmd ${UTILS} 

log_do "install OPAM, and dependencies" install_cmd ${OPAM_DEPS} ${OCAML_PKGS}

log_do "installing LLVM" install_cmd "llvm${LLVM_VER}"

ll_ver="$(llvm-config --version | sed 's/\(3\.[[:digit:]]\)\.0/\1/')"

report "installed LLVM version ${ll_ver}"

log_do "OPAM init" opam init --auto-setup

log_do "OPAM env" eval `opam config env`

log_do "install LLVM bindings (${ll_ver})" opam install -y llvm.${ll_ver}

log_do "install other OPAM packages" opam install -y ${OPAM_PKGS}

report "mega evolution complete!"
