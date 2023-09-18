# Workspace directory for SDG2

## Setup

1. Clone this repository
```bash
git clone git@github.com:sdg2DieUpm/workspace.git
```
2. Update git submodules
```bash
git submodule update --init --recursive
```

## Structure

- `cmake`: CMake modules, toolchain files, and platform-specific files.
- `drivers`: Drivers for the different boards.
- `ld`: Linker scripts for the different boards.
- `lib`: handy third-party libraries.
- `openocd`: OpenOCD configuration files for the different boards.
- `svd`: SVD files for the different boards.
- `CMakeLists.txt`: Main CMake file. Projects should `include` this file to automatically set up the toolchain and the project.
