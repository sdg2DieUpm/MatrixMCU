# MatrixMCU: a toolkit for developing bare-metal embedded applications

**MatrixMCU** is the acronym for **Microcontroller Application Toolkit Redefining Integrated Xperience for MCUs**

MatrixMCU is the name given to the set of tools and development environment (*toolkit*) for bare-metal programming on embedded devices with which we are going to work.
This toolkit has been tested for the 3 most important Operating Systems and it is intended to be used with the Visual Studio Code editor. 

## Installation and Setup

You must install additional tools to make `MatrixMCU` work.
To do so, follow the instructions of the [dependencies installer](https://github.com/sdg2DieUpm/install-MatrixMCU).

## After Installing MatrixMCU and all its Dependencies

The `projects/project_template` is a simple project for STM32F443RE boards that helps you verify the installation went well.
To do so, open this project template with Visual Studio Code and try to run a Debug Session of its main program.

You can copy the `projects/project_template` as many times as you want to start new projects.
Make sure that your new project is in the `projects/` folder.

> [!IMPORTANT]
Make sure that, when using Visual Studio Code, **THE PROJECT FOLDER IS THE WORKSPACE**.
Otherwise, Visual Studio Code won't be able to read the configurations and won't work.

## Structure

- `cmake`: CMake modules, toolchain files, and platform-specific files.
- `drivers`: Drivers for the different boards.
- `install`: Auxiliary installation scripts and instructions for required dependencies.
- `ld`: Linker scripts for the different boards.
- `lib`: handy third-party libraries.
- `openocd`: OpenOCD configuration files for the different boards.
- `projects`: Folder with all the projects of your workspace. When you first download `MatrixMCU`, you will have a template blink project.
- `svd`: SVD files for the different boards.
- `CMakeLists.txt`: Main CMake file. Projects should `include` this file to automatically set up the toolchain and the project.
