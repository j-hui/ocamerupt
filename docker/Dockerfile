FROM ocaml/opam
USER root
RUN DEBIAN_FRONTEND=noninteractive apt update -y && apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y llvm python2.7 cmake build-essential m4 pkg-config

USER opam
RUN opam update && opam upgrade
RUN opam install -y llvm.$(llvm-config --version | sed 's/\..$/.0/' | sed 's/\(3\.[[:digit:]]\)\.0/\1/')
