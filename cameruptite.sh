#!/bin/bash 

#### BEGIN: script configs
#           modify these as needed

# This will be overridden to @6 if on macOS because brew
#LLVM_VER=-6.0
LLVM_VER=


# You can also just not install any utilities
#UTILS=
UTILS="python3 clang tree htop git subversion vim emacs tmux"

OPAM_DEPS="gcc make python2.7 m4 pkg-config unzip cmake"
OCAML_PKGS="ocaml opam"
OPAM_PKGS="depext"


#### END: script configs

#### BEGIN: helper functions and initial setup

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

if [[ "$(id -u)" == "0" ]]; then
    report "$0 should not be run as root. It already contains sudo."
    exit 1
fi

case $(uname) in
    "Linux")
        case $(lsb_release -is) in
            "Debian"|"Ubuntu")
                # we assume apt already comes installed since Linux is for the l33t kids
                update_cmd() { sudo apt update -y && sudo apt upgrade -y ; }
                install_cmd() { sudo apt install -y "$@" ; }
                llvm_ver_cmd() { llvm-config${LLVM_VER} --version ; }
                ;;
            *)
                echo "Unsupported Linux distro, bailing now."
                exit 1
                ;;
        esac
        ;;
    "Darwin")
        if ! hash "$1" 2> /dev/null; then
            report "Installing Homebrew, a macOS package manager..."
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi

        LLVM_VER="@6"

        update_cmd() { brew update && brew upgrade ; }
        install_cmd() { brew install "$@" ; }
        llvm_ver_cmd() { "/usr/local/opt/llvm${LLVM_VER}/bin/llvm-config" --version ; }
        ;;
    *)
        echo "Unsupported operating system, bailing now."
        exit 1
        ;;
esac

#### END: helper functions and initial setup

#### BEGIN: actual script

set -eu

cd ~

log_do "update package manager" update_cmd

if [[ ! -z "${UTILS}" ]]; then
    log_do "install some handy utilities" install_cmd ${UTILS} 
fi

log_do "install OPAM, and dependencies" install_cmd ${OPAM_DEPS} ${OCAML_PKGS}

log_do "installing LLVM" install_cmd "llvm${LLVM_VER}"

ll_ver="$( llvm_ver_cmd | sed 's/\..$/.0/' | sed 's/\(3\.[[:digit:]]\)\.0/\1/')"

report "installed LLVM version ${ll_ver}"

if ! opam list &> /dev/null; then
    report "OPAM not initialized"
    log_do "OPAM init" opam init --auto-setup
    log_do "OPAM env" eval `opam config env`
fi

if [[ ! -z "${OPAM_PKGS}" ]]; then
    log_do "install other OPAM packages" opam install -y ${OPAM_PKGS}
fi

log_do "install LLVM bindings (${ll_ver})" opam install -y llvm.${ll_ver}

report "Mega evolution complete!"

#### END: actual script
