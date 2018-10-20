OCamerupt
=========

This repo contains some scripts and information about setting up a development
environment for writing a compiler in OCaml that targets LLVM IR.

Versioning Preamble
-------------------

The latest LLVM version is currently version 7. You need to install the OCaml
binding with the version corresponding to that of LLVM.

To make things slightly worse, what gets installed by default varies by OS and
distribution. We can work around any of these, but we need to be consistent.

### Installing with `opam`

Another gotcha: to install the `llvm` bindings using `opam`, you specify the
version after a period. However, `opam` is not smart about how many digits are
in the version number. After version 3.9, versions start going up in whole
numbers, but with a different format too. That is, these are your options:

    3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0.0, 5.0.0, 6.0.0, 7.0.0

So trying to install `llvm.3.8.0` will not work, nor will `llvm.6.0`. Watch out
for this if you're writing scripts.

### Determining LLVM version

To check your LLVM version, use the following command:

    llvm-config --version

This gives prints the version and nothing else on a single line, which is quite
suitable for parsing in shell scripts. For example, to obtain the version you
should give to `opam`, the following should work:

    llvm-config | sed 's/\..$/.0/' | sed 's/\(3\.[[:digit:]]\)\.0/\1/'

### LLVM `PATH`

When you install the non-default version of LLVM, the regular commands won't be
available. For example, on Ubuntu 16.04, after installing `llvm-6.0`, `lli`
won't exist.

On Debian-based systems, the commands will still be installed to `/usr/bin`, so
they should be on your path, but they will take the form:

    <llvm-command>-<version>

So in the example above, you'll have to run `lli-6.0`.

It works slightly differently on Darwin/macOS. None of the LLVMs are installed
to your local path (not even the default version), because `brew` complains that
the formula is "keg-only." Instead, they're all installed under a directory that
is not available to your `PATH` by default:

    /usr/local/opt/<formula>/bin/

For example, `llvm@6` will installed at:

    /usr/local/opt/llvm@6/bin/llvm-config

You can add this to your `PATH`, use `brew link --force` (at your own risk), or
make a bunch of symlinks yourself. To add this to your `PATH`, run the following
command:

    echo "export PATH=\"$(brew --prefix llvm)/bin:\$PATH\"" >> ~/.bash_profile

Then source the path into your current session:

    source ~/.bash_profile

Now you should be able to run the following:

    llvm-config --version

LLVM Versions
-------------

_Make sure to run `apt update` or `brew update` first_

Ubuntu 16.04 (`apt`): 3.5, 3.6, 3.7, **3.8**, 3.9, 4.0, 5.0, 6.0

Ubuntu 18.04 (`apt`): 3.7, 3.9, 4.0, 5.0, **6.0**

Debian 9 (`apt`): 3.7, **3.8**, 3.9, 4.0, 5.0, 6.0

Docker Ubuntu 16.04 (`apt`): 3.5, 3.6, 3.7, **3.8**, 3.9, 4.0, 5.0, 6.0

Docker Debian 9 (`apt`): 3.7, **3.8**, 3.9, 4.0

Darwin/macOS (`brew`): 3.9, 4(.0.1), 5(.0.2), 6(.0.1), **(7.0.0)**

_Default version in bold_

Note that for some reason, on macOS, the LLVM versions installed have additional
patch versions (e.g. 6.0.1 rather than 6.0.0).

Docker
------

### Docker primer

Very briefly, we can standardize our build environment using Docker.

We can create Docker "images," which are snapshots of virtual environments we've
provisioned using `Dockerfile`s. We create these images using `docker build .`,
which will perform changes to some base image from commands read from some
`Dockerfile` (which we can also specify with the `-f` flag if it's not located
at `./Dockerfile`). To see images available locally, use `docker image ls`.

Once we have that image, we can create instances of it using `docker run`,
passing it the image ID or tag so that it knows which image to instantiate. We
can also pass the `-it` flag to run the container in interactive mode to poke
around in a shell. We can restart stopped containers using `docker start`,
optionally passing the `--attach` flag to open up interactive mode. We can see
all the docker containers available by running `docker container ls`.

### LLVM versioning in Docker

For some reason, the packages available to `apt` and `opam` are different inside
Docker containers. In particular, the `ocaml/opam` image seems to be unable to
find any version later than 5.0.0.

### Where to go from here

Once images have been built, you should write another `Dockerfile` that uses the
built image as its base image, installs any additional dependencies for your
project, copies in any files or directories, and specifies a `CMD` which will be
the command that is run when you use `docker run`.
