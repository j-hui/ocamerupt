FROM ocaml/opam
USER root
RUN DEBIAN_FRONTEND=noninteractive apt update -y && apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y python2.7 cmake llvm build-essential m4 pkg-config

USER opam
RUN opam install -y llvm.$(llvm-config --version | sed 's/\(3\.[0-9]\)\.[0-9]/\1/')
