# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "tfel_binaries"
version = v"3.2.1-master"

# Collection of sources required to build tfelBuilder
sources = [
    "https://github.com/thelfer/tfel.git" =>
    "21e7b4e970f156fa325e25fd8fc79993ef179989",

]

# Bash recipe for building across all platforms
script = raw"""
export COMMON_FLAGS=\
"-DCMAKE_INSTALL_PREFIX=$prefix "\
"-DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain "\
"-Denable-portable-build=ON "

cd $WORKSPACE/srcdir/tfel/
apk add gnuplot
cmake $COMMON_FLAGS
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc)
    Linux(:x86_64, libc=:glibc)
    Linux(:aarch64, libc=:glibc)
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf)
    Linux(:powerpc64le, libc=:glibc)
    Linux(:i686, libc=:musl)
    Linux(:x86_64, libc=:musl)
    Linux(:aarch64, libc=:musl)
    Linux(:armv7l, libc=:musl, call_abi=:eabihf)
    # Windows(:i686)
    Windows(:x86_64)
    MacOS(:x86_64)
    # FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "mfront", :mfront),
    LibraryProduct(prefix, "libMTestFileGenerator", :libMTestFileGenerator),
    ExecutableProduct(prefix, "tfel-config", Symbol("tfel-config")),
    LibraryProduct(prefix, "libMFrontLogStream", :libMFrontLogStream),
    LibraryProduct(prefix, "libTFELTests", :libTFELTests),
    ExecutableProduct(prefix, "tfel-doc", Symbol("tfel-doc")),
    ExecutableProduct(prefix, "mfront-doc", Symbol("mfront-doc")),
    LibraryProduct(prefix, "libTFELMathKriging", :libTFELMathKriging),
    LibraryProduct(prefix, "libTFELGlossary", :libTFELGlossary),
    LibraryProduct(prefix, "libTFELConfig", :libTFELConfig),
    LibraryProduct(prefix, "libTFELMath", :libTFELMath),
    LibraryProduct(prefix, "libTFELMTest", :libTFELMTest),
    LibraryProduct(prefix, "libTFELMathParser", :libTFELMathParser),
    LibraryProduct(prefix, "libTFELUtilities", :libTFELUtilities),
    LibraryProduct(prefix, "libMFrontProfiling", :libMFrontProfiling),
    LibraryProduct(prefix, "libTFELMathCubicSpline", :libTFELMathCubicSpline),
    LibraryProduct(prefix, "libTFELMaterial", :libTFELMaterial),
    LibraryProduct(prefix, "libTFELNUMODIS", :libTFELNUMODIS),
    ExecutableProduct(prefix, "tfel-check", Symbol("tfel-check")),
    LibraryProduct(prefix, "libTFELSystem", :libTFELSystem),
    ExecutableProduct(prefix, "mfront-query", Symbol("mfront-query")),
    ExecutableProduct(prefix, "mtest", :mtest),
    LibraryProduct(prefix, "libTFELPhysicalConstants", :libTFELPhysicalConstants),
    LibraryProduct(prefix, "libTFELException", :libTFELException),
    LibraryProduct(prefix, "libTFELMFront", :libTFELMFront),
    ExecutableProduct(prefix, "mfm", :mfm)
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
