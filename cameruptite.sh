#!/bin/bash 

set -eu

#### BEGIN: script configs
#           modify these as needed

#LLVM_VER=-5.0
LLVM_VER=

UTILS="python3 clang tree htop git subversion vim emacs"
OPAM_DEPS="gcc make python2.7 m4 pkg-config unzip cmake"
OCAML_PKGS="ocaml opam"
OPAM_PKGS=

update_cmd() { sudo apt update -y && sudo apt upgrade -y ; }
install_cmd() { sudo apt install -y "$@" ; }

#### END: script configs


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

if [ "$(id -u)" == "0" ]; then
    report "$0 should not be run as root. It already contains sudo where needed."
    exit 1
fi

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


if [[ ! -z "${OPAM_PKGS}" ]]; then
    log_do "install other OPAM packages" opam install -y ${OPAM_PKGS}
fi

report "mega evolution complete!"
