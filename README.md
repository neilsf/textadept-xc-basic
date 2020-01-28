# XC=BASIC language module for Textadept

This module adds [XC=BASIC](https://xc-basic.net) syntax highlighting, file extension association, compile and build commands to [Textadept](https://foicica.com/textadept/index.html).

## Installation

1. Copy all files of this repository to _~/.textadept/_ (Linux and MAC OS) or _%userprofile%\.textadept\\_ (Windows). If the directory does not exist, create it.
2. Open the file _~/.textadept/init.lua_ (Linux and MAC OS) or _%userprofile%\.textadept\\init.lua_ (Windows). If it does not exist, create it.
3. Add the following lines:

    textadept.file_types.extensions.bas = 'xcbasic'
    textadept.run.run_commands.xcbasic = 'x64 "%e.prg"'
    textadept.run.compile_commands.xcbasic = '/path/to/xc-basic/xcb "%f" "%e.prg"'

