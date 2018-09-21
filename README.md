OCamerupt
=========

This repo contains some scripts and information about setting up a development
environment for writing a compiler in OCaml that targets LLVM IR.

Versioning Preamble
-------------------

The latest LLVM version is currently version 7. Unfortunately, there are only
OCaml bindings for up to version 6. You need to install the OCaml binding with
the version corresponding to that of LLVM.

To make things slightly worse, what gets installed by default varies by OS and
distribution. We can work around any of these, but we need to be consistent.

### Installing with `opam`

Another gotcha: to install the `llvm` bindings using `opam`, you specify the
version after a period. However, `opam` is not smart about how many digits are
in the version number. After version 3.9, versions start going up in whole
numbers, but with a different format too. That is, these are your options:

    3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0.0, 5.0.0, 6.0.0

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

You'll need to escape the `@` character if you're using Bash.

You can add this to your `PATH`, use `brew link --force` (at your own risk), or
make a bunch of symlinks yourself.

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
