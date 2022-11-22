# Railway Operation Simulator Installer

This repository contains scripts for compiling an installer for Railway Operation Simulator using [Nullsoft Scriptable Install System](https://nsis.sourceforge.io) (NSIS).
Additional components have been added to the installer to also include optional installs of [RailOSPkgManager](https://railway-op-sim.github.io/RailOSPkgManager/) and [json2ttb](https://github.com/Railway-Op-Sim/json2ttb).

## Requirements

* [NSIS](https://nsis.sourceforge.io)
* [EnVar Plugin](https://nsis.sourceforge.io/EnVar_plug-in)
* [AccessControl Plugin](https://nsis.sourceforge.io/AccessControl_plug-in) (for x86 systems copy the i386 version to `Plugins` folder).
* [nsisunz Plugin](https://nsis.sourceforge.io/Nsisunz_plug-in)
* Railway Operation Simulator package (placed in `Railway_Operation_Simulator` folder in the same location as this repository).
* RailOSPkgManager Package (placed in `RailOSPkgManager` folder in the same location as this repository).
* RailOSLauncher executable and icon file (placed in `RailOSLauncher` folder in the same location as this repository).
* Json2TTB `json2ttb.jar` file (placed in `json2ttb` folder in the same location as this repository).

## Compilation

Compile the installer by opening NSIS and clicking `Compile NSI scripts` then dragging the `.nsi` folder to the open window.