# Workspace directory for SDG2

## Prerequisites

You must install additional tools to make this workspace work.
For MacOS and Ubuntu users, check the [`installer`](https://github.com/sdg2DieUpm/installer/tree/main) repository.
For Windows users, check the SDG2 course guide.

## Setup

1. Clone this repository and move to the `workspace` directory:
```bash
git clone https://github.com/sdg2DieUpm/workspace.git && cd workspace
```
2. Update git submodules to download all the dependencies:
```bash
git submodule update --init --recursive
```
3. You can copy the `projects/project_template` as many times as you want to start new projects.

Make sure that, when using Visual Studio Code, **THE PROJECT FOLDER IS THE WORKSPACE**.
Otherwise, VSCode won't be able to read the configurations and won't work.

## Structure

- `cmake`: CMake modules, toolchain files, and platform-specific files.
- `drivers`: Drivers for the different boards.
- `ld`: Linker scripts for the different boards.
- `lib`: handy third-party libraries.
- `openocd`: OpenOCD configuration files for the different boards.
- `projects`: Folder with all the projects of your workspace. When you first download this workspace, you will have a template blink project.
- `svd`: SVD files for the different boards.
- `CMakeLists.txt`: Main CMake file. Projects should `include` this file to automatically set up the toolchain and the project.
