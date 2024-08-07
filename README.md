# ch32v307-no-sdk

![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Version](https://img.shields.io/badge/version-1.0.0-green.svg)

## Description

This is a minimal build-environment to programm the ch32v3007.
Just create a new folder for you project copy the minimal Makefile and done.

Makefile:
```make
all: flash

TARGET:=./examples/gpio/

include ../../ch32v307.mk

flash: cv_flash
clean: cv_clean
```

## Installation

```bash
# Clone the repository
git clone https://github.com/x0sig/ch32v307-no-sdk

# Navigate into the directory
cd ch32v307-no-sdk

# Install dependencies

# it uses the riscv-compiler:
https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack
# and the flasher tool:
https://github.com/ch32-rs/wlink

# Run the application
make
make clean
# Running make also flashes the project automatically
```

## References

this project is based on: \
`https://github.com/openwch/ch32v307` \
and inspired by: \
`https://github.com/cnlohr/ch32v003fun`
