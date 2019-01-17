# TurboPack DOSCommand

Updated for **10.3 Rio** / VER330 / PKG 260

You can still access [10.2 Tokyo](https://github.com/TurboPack/DOSCommand/releases/tag/102Tokyo) and [10.1 Berlin](https://github.com/TurboPack/DOSCommand/releases/tag/101Berlin) versions too.

## Table of contents

1.  Introduction
2.  Package names
3.  Installation
4.  License

## 1. Introduction

TurboPack DOSCommand component let you execute a dos program (exe, com or batch file) and catch
the ouput in order to put it in a memo or in a listbox, ...
You can also send inputs.

The cool thing of this component is that you do not need to wait the end of
the program to get back the output. it comes line by line.

This is a source-only release of TurboPack DOSCommand. It includes
designtime and runtime packages for Delphi and C++Builder. It supports Win32 and Win64.

## 2. Package names

TurboPack DOSCommand package names have the following form:

## Delphi 
* DOSCommandDR.bpl (Delphi Runtime)
* DOSCommandDD.bpl (Delphi Designtime)

## C++Builder
* DOSCommandCR.bpl (C++Builder Runtime)
* DOSCommandCD.bpl (C++Builder Designtime)

The runtime package contains the core functionality of the product and
is not installed into the IDE. The designtime package references the
runtime package, registers the components, and contains property
editors used in the IDE.

## 3. Installation

DOSCommand is available via the [GetIt Package Manager](http://docwiki.embarcadero.com/RADStudio/en/Installing_a_Package_Using_GetIt_Package_Manager) where you can quickly and easily install and uninstall it.

To manually  install TurboPack DOSCommand into your IDE, take the following
steps:

  1. Unzip the release files into a directory (e.g., `d:\DOSCommand`).

  2. Start RAD Studio.

  3. Add the source subdirectory (e.g., `d:\DOSCommand\source`) to the
     IDE's library path. For CBuilder, add the hpp subdirectory
     (e.g., `d:\essence\source\hpp\Win32\Release`) to the IDE's system include path.

  4. Open & compile the runtime package specific to the IDE being
     used.

  5. Open & install the designtime package specific to the IDE being
     used. The IDE should notify you the components have been
     installed.

## 4. License

[Mozilla Public License 1.1 (MPL 1.1)](https://www.mozilla.org/en-US/MPL/1.1/)
