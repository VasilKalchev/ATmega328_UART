ATmega328 UART
==============

[![Download](https://img.shields.io/badge/download-1.0.0-blue.svg?style=flat-square&logo=github&logoColor=white)](https://github.com/VaSe7u/ATmega328_UART/archive/1.0.0.zip)
[![Documentation](https://img.shields.io/badge/docs-doxygen-orange.svg?style=flat-square)](https://vase7u.github.io/ATmega328_UART/docs/Doxygen/html/index.html)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat-square)](https://opensource.org/licenses/mit-license.php)

*Library for the UART on the ATmega328/P.*

Table of Contents
-----------------
 - [Features](#features)
 - [Prerequisites](#prerequisites)
 - [Getting started](#getting-started)
   + [Building and uploading using one of the provided *`Makefile`s*](#building-and-uploading-using-one-of-the-provided-makefiles-page_with_curl)
   + [Building and uploading manually](#building-and-uploading-manually-wrench)
 - [License](#license)

Features
--------
 - Polling implementation
 - Interrupts implementation
 - Formatted IO streams implementation

Prerequisites
-------------
 - ATmega328/P
 - AVR-GCC

Getting started
---------------
 - [Download the repository][download_repo].
 - Take a look at the [documentation][documentation_link].
 - Use the examples inside [*`/ATmega328_UART/examples/`*][examples_path].

---

### Building and uploading using one of the provided *`Makefile`s* :page_with_curl:
> _Prerequisites: AVR-GCC and Make_

#### Building **`ATmega328_UART`** to a static library
 - Open *`.../ATmega328_UART/Makefile`* and edit the variables: `$HOST_PLATFORM`, `$F_CPU` and `$UART_BAUD`.
 - Execute `> make` inside *`.../ATmega328_UART/`* to recompile the library according to the specified frequency and baud rate.
> :grey_exclamation: *The library must be recompiled every time `$F_CPU` and/or `$UART_BAUD` variables are changed!*

#### Building and uploading an example
 - Open the *`Makefile`* that is in the root directory of the chosen example _(e.g. *`/ATmega328_UART/examples/IO_streams/Makefile`*)_ and edit the variables: `$HOST_PLATFORM`, `$F_CPU`, `$PROGRAMMER` and `$PORT`.
 - Execute `> make` inside the same directory to build the example.
 - And finally execute `> make program` to upload it to the AVR target.

#### Building and uploading a new project using one of the example's *`Makefile`*
This is the same as ['Building and uploading an example'](#building-and-uploading-an-example) except that the *`Makefile`* should be configured for the new project _(e.g. the target name, the new location of the library, etc)_.

---

### Building and uploading manually :wrench:
The library can be compiled and linked to a project using a different build system _(e.g. a user's *`Makefile`*, an IDE, etc)_. The location of the header file is *`.../ATmega328_UART/include/ATmega328_UART.h`* and the location of the source file is *`../ATmega328_UART/src/ATmega328_UART.c`*.

> _`F_CPU` and `BAUD` macros must be defined._

> :grey_exclamation: _The library must be recompiled every time `F_CPU` and/or `BAUD` macros are changed!_


> When using formatted IO streams, the libraries *printf* and/or *scanf* should be linked[<sup>1</sup>](#1). AVR-GCC linker flags:
> - `-Wl,-u,vfprintf -lprintf_min`
> - `-Wl,-u,vfprintf -lprintf_flt -lm`
> - `-Wl,-u,vfscanf -lscanf_min`
> - `-Wl,-u,vfscanf -lscanf_flt -lm`


License
-------
The MIT License (MIT)

Copyright (c) 2019 Vasil Kalchev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

<a class="anchor" id="1"></a> 1. [avr-libc: <stdio.h>][printf_linking_link] documentation


[download_repo]: https://github.com/VaSe7u/ATmega328_UART/archive/1.0.0.zip
[documentation_link]: https://VaSe7u.github.io/ATmega328_UART/docs/Doxygen/html/index.html
[examples_path]: /examples
[printf_linking_link]: https://www.nongnu.org/avr-libc/user-manual/group__avr__stdio.html
