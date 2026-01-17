##################################################################################################
# Simker dockerfile                                                                              #
#                                                                                                #
# l.heywang <leonard.heywang@proton.me>                                                          #
# 03-01-2026                                                                                     #
#                                                                                                #
# Build an electronic simulation docker, with all of the tools needed for both digital (GHDL,    #
#    Verilator) or analog (Ngspice) simulation. Include openvaf-r for veriloga behavioral models.#
#    Does also include viewers as Gtkwave and Gaw (3).                                           #
#                                                                                                #
# This image is a two step build : First, compile from source the tools, and then, copy the      #
#    binaries into a newer container. This enable smaller images (~2 GB compared to 10 GB ones), #
#    while retaining the same performance nor advantages.                                        #
#                                                                                                #
##################################################################################################

# ================================================================================================
# First stage build image
# ================================================================================================
# Base image
FROM ubuntu:24.04 AS build
WORKDIR /work

# Updating OS to the latest versions
RUN apt-get update --fix-missing && apt-get upgrade -y --fix-missing 
RUN apt-get update && apt-get install -y -f

# Install software build dependencies
RUN apt-get update && apt-get install -y --fix-missing \
    cmake \
    make \
    texinfo \
    automake \
    autoconf \
    gcc \
    g++ \
    build-essential \
    git \
    wget \
    ccache \
    curl \
    unzip

# -----------------------------------------------------------------------------------------------
# Verilator deps : 
# -----------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --fix-missing \
    help2man \
    perl \
    python3 \
    libfl2 \
    libfl-dev \
    zlib1g \
    zlib1g-dev \
    libsystemc \
    libsystemc-dev \
    perl-doc \
    z3 \
    mold \
    libgoogle-perftools-dev \
    numactl \
    flex \
    bison \
    python3-distro

# -----------------------------------------------------------------------------------------------
# GHDL deps : 
# -----------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --fix-missing \
    gnat \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev

# -----------------------------------------------------------------------------------------------
# NGSPICE deps
# -----------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --fix-missing \
    libtool \
    libxaw7-dev \
    libreadline-dev

# -----------------------------------------------------------------------------------------------
# XSCHEM deps :
# -----------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --fix-missing \
    mawk \
    libx11-dev \
    libxpm-dev \
    flex \
    bison \
    libcairo2-dev \
    xcb \
    libxrender-dev \
    xterm

# -----------------------------------------------------------------------------------------------
# GAW3 deps :
# -----------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --fix-missing \
    libgtk-4-dev

# -----------------------------------------------------------------------------------------------
# GTKWave deps :
# -----------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --fix-missing \
    meson \
    gperf \
    flex \
    desktop-file-utils \
    libgtk-3-dev \
    tcl-dev \
    tk-dev \
    libbz2-dev \
    libjudy-dev \
    liblzma-dev \
    libgirepository1.0-dev \
    libjson-glib-dev

# -----------------------------------------------------------------------------------------------
# OpenVAF-Reloaded deps
# -----------------------------------------------------------------------------------------------
# Get C compilers
RUN apt-get update && apt-get install -y --fix-missing \
    llvm \
    clang

# Installing rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    ls -la /root/.cargo/ && \
    cat /root/.cargo/env

ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup toolchain install stable && \
    rustup default stable && \
    cargo --version

# -----------------------------------------------------------------------------------------------
# Output structure creation
# -----------------------------------------------------------------------------------------------

# Creating future folders
RUN mkdir /work/build_tmp

# Creating output folders
RUN mkdir /tools
RUN mkdir /tools/verilator
RUN mkdir /tools/ghdl
RUN mkdir /tools/ngspice
RUN mkdir /tools/xschem
RUN mkdir /tools/gaw3
RUN mkdir /tools/gtkwave
RUN mkdir /tools/openvaf-r

# ================================================================================================
# Tools installation
# ================================================================================================
# Fetching the different elements : 
WORKDIR /work/build_tmp
RUN git clone --recursive -j 4 https://github.com/verilator/verilator.git verilator
RUN git clone --recursive -j 4 https://github.com/ghdl/ghdl.git ghdl
RUN git clone --recursive -j 4 https://git.code.sf.net/p/ngspice/ngspice ngspice
RUN git clone --recursive -j 4 https://github.com/StefanSchippers/xschem.git xschem
RUN git clone --recursive -j 4 https://github.com/StefanSchippers/xschem-gaw.git gaw3
RUN git clone --recursive -j 4 https://github.com/gtkwave/gtkwave.git gtkwave
RUN git clone --recursive -j 4 https://github.com/OpenVAF/OpenVAF-Reloaded.git openvaf-r

# Get sources of GCC (for GHDL build)
WORKDIR /work/res
RUN wget https://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-12.5.0/gcc-12.5.0.tar.gz
RUN mkdir gcc
RUN tar -xf *.tar.gz -C gcc --strip-components=1

# Compiling the different tools :
# -----------------------------------------------------------------------------------------------
# Verilator
# -----------------------------------------------------------------------------------------------
WORKDIR /work/build_tmp/verilator

RUN unset VERILATOR_ROOT

RUN git pull && git checkout stable
RUN autoconf
RUN ./configure --prefix /tools/verilator
RUN make -j8
RUN make test
RUN make install

# -----------------------------------------------------------------------------------------------
# GHDL
# -----------------------------------------------------------------------------------------------
WORKDIR /work/build_tmp/ghdl
RUN mkdir build 
WORKDIR /work/build_tmp/ghdl/build

RUN ../configure --with-gcc=/work/res/gcc --prefix=/tools/ghdl
RUN make copy-sources

RUN mkdir gcc-objs
WORKDIR /work/build_tmp/ghdl/build/gcc-objs

RUN /work/res/gcc/configure \
    --prefix=/tools/ghdl \
    --enable-languages=c,vhdl \
    --disable-bootstrap \
    --disable-lto \
    --disable-multilib \
    --disable-libssp \
    --disable-libgomp \
    --disable-libquadmath \
    --enable-default-pie
RUN make -j8 
RUN make install

WORKDIR /work/build_tmp/ghdl/build
RUN make ghdllib
RUN make install

# -----------------------------------------------------------------------------------------------
# NGSPICE
# -----------------------------------------------------------------------------------------------
WORKDIR /work/build_tmp/ngspice

RUN ./autogen.sh
RUN mkdir debug

WORKDIR /work/build_tmp/ngspice/debug

RUN ../configure --with-x --enable-cider --enable-xspice --with-readline=yes --enable-openmp --disable-debug --prefix=/tools/ngspice
RUN make -j8
RUN make install

# -----------------------------------------------------------------------------------------------
# XSCHEM
# -----------------------------------------------------------------------------------------------
WORKDIR /work/build_tmp/xschem

RUN ./configure 
RUN make -j8
RUN make install DESTDIR=/tools/xschem

# -----------------------------------------------------------------------------------------------
# GAW3
# -----------------------------------------------------------------------------------------------
WORKDIR /work/build_tmp/gaw3

RUN ./configure --prefix=/tools/gaw3
RUN make -j8
RUN make install

# -----------------------------------------------------------------------------------------------
# GTKWAVE
# -----------------------------------------------------------------------------------------------
WORKDIR /work/build_tmp/gtkwave

RUN meson setup build --prefix=/tools/gtkwave
WORKDIR /work/build_tmp/gtkwave/build
RUN meson install

# -----------------------------------------------------------------------------------------------
# OpenVAF-Reloaded
# -----------------------------------------------------------------------------------------------
WORKDIR /work/build_tmp/openvaf-r

RUN cargo build --release --bin openvaf-r
RUN cargo test --release

# Hand copy the output binary 
RUN mkdir -p /tools/openvaf-r/bin
RUN cp target/release/openvaf-r /tools/openvaf-r/bin/

# ===============================================================================================
# Finishing up things
# ===============================================================================================
# Cleaning up the build folders 
RUN rm -rf /work/build_tmp

# Stripping the binaries : 
RUN strip /tools/**/bin/* || true

# ===============================================================================================
# Second stage build (as runtime)
# ===============================================================================================
# Base image
FROM ubuntu:24.04 AS runtime

# Updates and runtime libs install
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y --fix-missing \
    libx11-6 \
    libxrender1 \
    libxext6 \
    libxft2 \
    libgtk-3-0 \
    libgtk-4-1 \
    libcairo2 \
    libglib2.0-0 \
    libstdc++6 \
    ca-certificates

# Add a nice utility to edit files from the docker
RUN apt-get update && apt-get install -y --fix-missing \
    nano \
    git \
    curl \
    wget \
    unzip \
    xterm

# ===============================================================================================
# Install dependencies
# ===============================================================================================
# Installing runtime dependencies
RUN apt-get update && apt-get install -y --fix-missing \
    libgnat-13 \  
    tcl8.6 \
    tk8.6 \
    perl \
    libgomp1 \
    llvm-18 \
    libjudy-dev \
    llvm \
    clang \
    g++ \
    ccache \
    make \
    zlib1g-dev \
    build-essential \
    mold \
    iverilog \
    python3-jinja2 \
    python3-ply \
    python3-setuptools
    
# ===============================================================================================
# Display configuration
# ===============================================================================================
# Installing deps 
RUN apt-get update && apt-get install -y --fix-missing \
    xauth \
    x11-apps \
    libxext6 \
    libxrender1 \
    libxft2

# Set default to DISPLAY (will be changed when creating the docker with the host variable)
ENV DISPLAY=:0

# ===============================================================================================
# Setting the path and variables
# ===============================================================================================
# Setting up the PATH
ENV PATH="/tools/gaw3/bin:${PATH}"
ENV PATH="/tools/ghdl/bin:${PATH}"
ENV PATH="/tools/gtkwave/bin:${PATH}"
ENV PATH="/tools/ngspice/bin:${PATH}"
ENV PATH="/tools/verilator/bin:${PATH}"
ENV PATH="/tools/xschem/usr/local/bin:${PATH}"
ENV PATH="/tools/openvaf-r/bin/:${PATH}"
ENV PATH="/tools/scripts/:${PATH}"
ENV PATH="/home/ubuntu/.local/bin/:${PATH}"

# Adding a variable to make sure xschem can start
ENV XSCHEM_SHAREDIR="/tools/xschem/usr/local/share/xschem"

# Update library path for xschem
ENV XSCHEM_LIBRARY_PATH="/tools/xschem/usr/local/share/xschem/xschem_library/devices/"
ENV XSCHEM_LIBRARY_PATH="/tools/xschem/usr/local/share/xschem/systemlib/:${XSCHEM_LIBRARY_PATH}"

# Add a ngspice lib path : 
ENV NGSPICE_LIB_DIR=/tools/lib/

# ===============================================================================================
# Install final tools 
# ===============================================================================================
# Prepare /tools folder
RUN mkdir -p /tools

# Install Pyverilog parser
RUN mkdir -p /tools/pyverilog
WORKDIR /tools
RUN git clone --recursive -j 4  https://github.com/PyHDI/Pyverilog.git pyverilog

# Launch install
WORKDIR /tools/pyverilog
RUN python3 setup.py install

# ===============================================================================================
# Import binaries, tools and static data
# ===============================================================================================
# Creating folders : 
RUN mkdir -p /tools/scripts
RUN mkdir -p /tools/doc
RUN mkdir -p /workspace
RUN mkdir -p /examples

# Import scripts
COPY ./scripts /tools/scripts
COPY ./doc /tools/doc

# Import examples
COPY ./examples /examples

# Copy binaries (last step, to let all the previous step run while building the first image)
COPY --from=build /tools /tools

# ===============================================================================================
# Running install script, to gather some versions : 
# ===============================================================================================
# Get tools versions : 
RUN /tools/scripts/getversions

# ===============================================================================================
# Configure a new user with permissions (will make link between things easier)
# ===============================================================================================
# Block the user to modify the scripts / tools
RUN chmod -R 755 /tools

# Enable the user the folders where it need : 
RUN chmod -R 777 /examples
RUN chmod -R 777 /workspace

# ===============================================================================================
# Final cleanup
# ===============================================================================================
# Cleaning some things
RUN rm -rf /var/lib/apt/lists/*

# ===============================================================================================
# Set docker active user 
# ===============================================================================================
# Setting up user
USER ubuntu
WORKDIR /workspace

# Install oh-my-posh config (This must be done as user, to, here we don't have others choices)
RUN curl -s https://ohmyposh.dev/install.sh | bash -s
RUN echo 'eval $(oh-my-posh init bash --config atomic)' >> $HOME/.bashrc

# ===============================================================================================
# Set docker entrypoint 
# ===============================================================================================
# And, here a small useless command to trigger a rebuild: 
RUN echo "Hello World from Dockerfile !"

# Setting CMD / ENTRYPOINT
ENTRYPOINT ["/bin/sh"]
CMD ["/tools/scripts/simker"]
