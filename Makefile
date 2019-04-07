# Configurable Makefile for compiling executable and library
# projects, natively and for AVR.

# How to use it:
# --------------
# Almost all of the user configuration is done in section "2. USER
# CONFIGURATION".
# When using static libraries as dependencies, additional rules for
# making and cleaning the libraries must be added manually (search
# for `USER_CONFIG_STATIC_LIBS`).

# Commands:
# ---------
# All
#| Command                            | Description                                                                                    | Native executable      | AVR executable         | Library                          |
#| ---------------------------------- | ---------------------------------------------------------------------------------------------- | ---------------------- | ---------------------- | -------------------------------- |
#| `make init`                        | creates folders for the project based on the user configuration                                |                        |                        |                                  |
#| `make`                             | compiles and...                                                                                | links to an executable | links to an executable | creates a static library archive |
#| `run`                              | runs the executable                                                                            |                        | *disabled*             | *disabled*                       |
#| `make all`                         | in addition to `make` compiles and runs the tests and generates the documentation              |                        |                        |                                  |
#| `make ObjectDump`                  | extracts information from the linked object into *`(TARGET).lss`* file                         |                        |                        | *disabled*                       |
#| `make SymbolTable`                 | extracts symbol table from the linked object into *`(TARGET).sym`* file                        |                        |                        | *disabled*                       |
#| `make deps`                        | "makes" all static library dependencies                                                        |                        |                        |                                  |
#| `make <STATIC_LIBRARY_NAME>`       | "makes" the specified static library                                                           |                        |                        |                                  |
#| `make tests`                       | compiles and runs the tests                                                                    |                        |                        |                                  |
#| `make docs`                        | generates the documentation                                                                    |                        |                        |                                  |
#| `make clean`                       | cleans the project generated files                                                             |                        |                        |                                  |
#| `make clean_all`                   | in addition to `clean` also "cleans" the dependencies                                          |                        |                        |                                  |
#| `make clean_<STATIC_LIBRARY_NAME>` | cleans the specified static library                                                            |                        |                        |                                  |
#
# AVR only
#| Command                            | Description                                                                                    | Native executable      | AVR executable         | Library                          |
#| ---------------------------------- | ---------------------------------------------------------------------------------------------- | ---------------------- | ---------------------- | -------------------------------- |
#| `make program`                     | links to an executable, converts the executable to ihex format and writes it to the target AVR | *disabled*             |                        | *disabled*                       |
#| `make program_flash`               | *same as `make program`*                                                                       | *disabled*             |                        | *disabled*                       |
#| `make download_flash`              | reads the AVR's flash into a file                                                              | *disabled*             |                        | *disabled*                       |
#| `make program_eeprom`              | `make program` but only writes the EEPROM                                                      | *disabled*             |                        | *disabled*                       |
#| `make download_eeprom`             | reads the AVR's eeprom into a file                                                             | *disabled*             |                        | *disabled*                       |
#| `make program_fuses`               | writes the configured fuse settings to the target AVR                                          | *disabled*             |                        | *disabled*                       |
#| `make download_fuses`              | reads the AVR's fuses into files                                                               | *disabled*             |                        | *disabled*                       |
#| `make <TARGET>.hex`                | compiles, links and converts to ihex                                                           | *disabled*             |                        | *disabled*                       |
#| `make <TARGET>.eep`                | compiles, links and converts to ihex (just the .eeprom section)                                | *disabled*             |                        | *disabled*                       |

# What can be added:
# ------------------
# - shared library dependencies
# - compiling shared libraries
# - configuration of static libraries in one place
# - support for other GCC backends
# - C and C++ source mixing
# - C test framework


# 1. DEFAULTS -------------------------------------------------------
# Project specific extensions
.SUFFIXES: # first remove all
.SUFFIXES: .c .h .cpp .hpp .o .d

# Default folder names. Used for convenience when configuring locations.
INCLUDE_DIR_DEFAULT := include
LIB_DIR_DEFAULT := lib

# Arrays for collecting all of something.
SRC_DIRS_ALL :=
STATIC_LIBRARIES_NAMES_ALL :=
STATIC_LIBRARIES_DIRS_ALL :=
STATIC_LIBRARIES_INCLUDE_DIRS_ALL :=
# DEFAULTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 2. USER CONFIGURATION ---------------------------------------------
# This variable specifies the output of the compilation. Currenlty
## supported outputs are 'executable' and 'staticLibrary'.
PROJECT_TYPE := staticLibrary# executable or staticLibrary

# The name of the compiled executable or library.
TARGET := ATmega328_UART

# This variable can be left empty when compiling natively. When the
## variable is specified, a different compiler toolchain will be used
## the output will be placed under a folder with the same name (e.g.
## /bin/x86/Debug/main.exe). 
TARGET_ARCHITECTURE := AVR#(empty), x86, AVR...

# The default build type that will be used. Available options are
## `DEBUG`, `RELEASE` or leaving it empty. To select different build
## type, it needs to be explicitly specified when running make (e.g.
## "make BUILD_TYPE=RELEASE"). To effectively disable different build
## types, leave the default build type empty. When using `RELEASE`
## build type `NDEBUG` macro will be defined.
DEFAULT_BUILD_TYPE ?= RELEASE

SRC_EXTENSION := c
OBJ_EXTENSION := o

# Folder names -----
BUILD_DIR := build# objects
DEPS_DIR := deps# external static libraries
SRC_DIR := src# sources and private headers
DOCS_DIR := docs# documentation
TESTS_DIR := tests

ifeq ($(PROJECT_TYPE), executable)
BIN_DIR := bin# executable
else ifeq ($(PROJECT_TYPE), staticLibrary)
INLCUDE_DIR := include# public headers
LIB_DIR := lib# static library archive
EXAMPLES_DIR := examples
INCLUDE_DIR := include# public headers
else
$(error Invalid project type: '$(PROJECT_TYPE)' !)
endif

# Additional source directories. When there are multiple folders that
## contain source files (including subdirectories), they need to be
## added to the array SRC_DIRS_ALL.
# SRC_DIRS_ALL += $(SRC_DIR)/component1
# Folder names ~~~~~

# Static libraries -----
# Four things must be specified here: the name, the base directory,
## the include directory and the archive directory. After that the
## name, the include directory and the archive directory must be
## added to the arrays that collect all of them.
# To complete the configuration search for `USER_CONFIG_STATIC_LIBS`.

# Static library 1 ---
# STATIC_LIBRARY_1_NAME := Ext1
# STATIC_LIBRARY_1_BASE_DIR := $(DEPS_DIR)/$(STATIC_LIBRARY_1_NAME)
# STATIC_LIBRARY_1_INCLUDE_DIR := $(STATIC_LIBRARY_1_BASE_DIR)/$(INCLUDE_DIR_DEFAULT)
# STATIC_LIBRARY_1_DIR := $(STATIC_LIBRARY_1_BASE_DIR)/$(LIB_DIR_DEFAULT)

# STATIC_LIBRARIES_NAMES_ALL += $(STATIC_LIBRARY_1_NAME)
# STATIC_LIBRARIES_INCLUDE_DIRS_ALL += $(STATIC_LIBRARY_1_INCLUDE_DIR)
# STATIC_LIBRARIES_DIRS_ALL += $(STATIC_LIBRARY_1_DIR)
# Static library 1 ~~~
# Static libraries ~~~~~

# Tests -----
# The location of the Boost libraries (only Boost is supported).
BOOST_DIR :=
# Tests ~~~~~

# AVR specific configuration -----
# (can be deleted)
ifeq ($(TARGET_ARCHITECTURE), AVR)
MCU := atmega328p
F_CPU := 16000000UL
UPLOADER := avrdude
PROGRAMMER := arduino# usbasp-clone
PORT := COM4
BAUD := 115200
LOW_FUSE := 0xFF
HIGH_FUSE := 0xDE
EXT_FUSE := 0x05

# Choose the printf and scanf libraries that will be linked.
PRINTF_LIB := minimal#minimal, (empty) or float
SCANF_LIB := minimal#minimal, (empty) or float
UART_BAUD := 9600
endif
# AVR specific configuration ~~~~~

# Compiler configuration -----
CC := gcc
CC_OPTIONS := -MMD # needed for generating header dependency files
CC_OPTIONS += -ffunction-sections -fdata-sections
CC_OPTIONS += -g # produce debugging information for GDB
# CC_OPTIONS += -save-temps=obj
CC_OPTIONS += -time # report the CPU time taken by compilation
CC_WARNINGS := -Wall -Wextra #-Werror -pedantic #-pedantic-errors
CC_WARNINGS += -Wunreachable-code -Wsign-compare #-Weffc++
CC_OPTIMIZATION := -Os
CC_STANDARD := -std=c99 #gnu++11

# Additional compiler configuration for AVR ---
ifeq ($(TARGET_ARCHITECTURE), AVR)
CC := avr-gcc
CC_OPTIONS += -mcall-prologues
# CC_OPTIONS += -fno-threadsafe-statics
CC_OPTIONS += -fno-exceptions
CC_OPTIONS += -ffunction-sections -fdata-sections
CC_OPTIONS += -funsigned-char
CC_OPTIONS += -funsigned-bitfields
CC_OPTIONS += -fpack-struct
CC_OPTIONS += -fshort-enums
endif
# Additional compiler configuration for AVR ~~~
# Compiler configuration ~~~~~


# Linker configuration -----
ifeq ($(PROJECT_TYPE), executable)
LD := gcc
LD_OPTIONS := -lm
LD_OPTIONS += -static
LD_OPTIONS += -Wl,--gc-sections,--relax
LD_OPTIONS += -g# Produce debugging information for GDB
LD_OPTIMIZATION := -Os
GENERATE_MAP_FILE := TRUE

# Additional linker configuration for AVR ---
ifeq ($(TARGET_ARCHITECTURE), AVR)
LD := avr-gcc
endif # if avr
# Additional linker configuration for AVR ~~~

endif # if executable project
# Linker configuration ~~~~~


# Archiver configuration -----
AR := gcc-ar
AR_FLAGS := -rcs

ifeq ($(TARGET_ARCHITECTURE), AVR)
AR := avr-ar
AR_FLAGS := -rcs
endif
# Archiver configuration ~~~~~


# Format converting for AVR -----
ifeq ($(TARGET_ARCHITECTURE), AVR)
OBJCOPY := avr-objcopy
FORMAT := ihex
TEXT_FLAGS := -j .text -j .data
EEP_FLAGS := -j .eeprom --set-section-flags=.eeprom=alloc,load \
  --no-change-warnings --change-section-lma .eeprom=0
endif
# Format converting for AVR ~~~~~


# Other tools -----
RM := -rm
MKDIR := -mkdir

# Enable/disable documentation generation.
GENERATE_DOCUMENTATION := TRUE
DOC_TOOL := doxygen
DOC_CONFIG_FILE := Doxyfile# the name of the doxygen config file
DOC_TOOL_SUBFOLDER := Doxygen

SIZE := size
OBJDUMP := objdump
NM := nm

ifeq ($(TARGET_ARCHITECTURE), AVR)
SIZE := avr-size -C --mcu=$(MCU)
OBJDUMP := avr-objdump
NM := avr-nm
endif
# Other tools ~~~~~

# USER CONFIGURATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 3. LOGIC ----------------------------------------------------------
# Platform -----
ifeq ($(OS),Windows_NT)
	SHELL = C:/Windows/System32/cmd.exe
	EXE_EXTENSION := exe
else
	SHELL = /bin/sh
	EXE_EXTENSION := out
endif

ifeq ($(TARGET_ARCHITECTURE), AVR)
EXE_EXTENSION := elf
endif
# Platform ~~~~~




ifeq ($(BUILD_TYPE), RELEASE)
CC_OPTIONS += -DNDEBUG# define NDEBUG
endif

# Append a subfolder based on the selected architecture -----
ifeq ($(TARGET_ARCHITECTURE),)
else
BUILD_DIR := $(BUILD_DIR)/$(TARGET_ARCHITECTURE)
ifeq ($(PROJECT_TYPE), executable)
BIN_DIR := $(BIN_DIR)/$(TARGET_ARCHITECTURE)
else ifeq ($(PROJECT_TYPE), staticLibrary)
LIB_DIR := $(LIB_DIR)/$(TARGET_ARCHITECTURE)
endif # if project_type
endif # if target_architecture
# Append a subfolder based on the selected architecture ~~~~~

# Append a subfolder based on the selected release -----
BUILD_TYPE ?= $(DEFAULT_BUILD_TYPE)

ifeq ($(BUILD_TYPE),)
else ifeq ($(BUILD_TYPE), RELEASE)
BIN_DIR := $(BIN_DIR)/Release
BUILD_DIR := $(BUILD_DIR)/Release
else ifeq ($(BUILD_TYPE), DEBUG)
BIN_DIR := $(BIN_DIR)/Debug
BUILD_DIR := $(BUILD_DIR)/Debug
else
$(error Invalid `BUILD_TYPE` selected: `$(BUILD_TYPE)`! Valid choices: (empty), `DEBUG` and `RELEASE`.)
endif
# Append a subfolder based on the selected release ~~~~~

# Compiler flags -----
ifeq ($(TARGET_ARCHITECTURE), AVR)
CC_OPTIONS += -mmcu=$(MCU) -DF_CPU=$(F_CPU) -DBAUD=$(UART_BAUD)
endif

CC_FLAGS := $(CC_OPTIONS) $(CC_WARNINGS) $(CC_OPTIMIZATION) $(CC_STANDARD)
# Compiler flags ~~~~~

# Append linker flags based on the selected configuration -----
ifeq ($(PROJECT_TYPE), executable)
LD_FLAGS := $(LD_OPTIONS) $(LD_OPTIMIZATION)

ifeq ($(GENERATE_MAP_FILE), TRUE)
LD_MAP_OPTION := -Wl,--cref,-Map=$(BIN_DIR)/$(TARGET).map
LD_FLAGS += $(LD_MAP_OPTION)
endif # if generate_map_file

ifeq ($(TARGET_ARCHITECTURE), AVR)
LD_FLAGS += -mmcu=$(MCU)

ifeq ($(PRINTF_LIB), minimal)
LD_FLAGS += -Wl,-u,vfprintf -lprintf_min
else ifeq ($(PRINTF_LIB), float)
LD_FLAGS += -Wl,-u,vfprintf -lprintf_flt -lm
endif # if printf_lib

ifeq ($(SCANF_LIB), minimal)
LD_FLAGS += -Wl,-u,vfscanf -lscanf_min
else ifeq ($(SCANF_LIB), float)
LD_FLAGS += -Wl,-u,vfscanf -lscanf_flt -lm
endif # if scanf_lib

endif # if avr

endif # if executable project
# Append linker flags based on the selected configuration ~~~~~


# Uploader configuration for AVR -----
ifeq ($(TARGET_ARCHITECTURE), AVR)
# REF: AVRdude main command: -U memtype:op:filename[:format]
UPLOADER_OPTIONS := -p$(MCU) -c$(PROGRAMMER) -P$(PORT) -b$(BAUD) -D
UPLOADER_OPTIONS_FLASH := -Uflash:w:$(BIN_DIR)/$(TARGET).hex:i
UPLOADER_OPTIONS_FLASH_DOWNLOAD := -Uflash:r:$(BIN_DIR)/$(TARGET)_flashdump.hex:i
UPLOADER_OPTIONS_EEPROM := -Ueeprom:w:$(BIN_DIR)/$(TARGET).eep:i
UPLOADER_OPTIONS_EEPROM_DOWNLOAD := -Ueeprom:r:$(BIN_DIR)/$(TARGET)_eepromdump.eep:i
UPLOADER_OPTIONS_FUSES := -Uhfuse:w:$(HIGH_FUSE):m -Ulfuse:w:$(LOW_FUSE):m -Uefuse:w:$(EXT_FUSE):m
UPLOADER_OPTIONS_FUSES_DOWNLOAD := -Uhfuse:r:$(BIN_DIR)/hfuse.txt:m -Ulfuse:r:$(BIN_DIR)/lfuse.txt:m -Uefuse:r:$(BIN_DIR)/efuse.txt:m
endif
# Uploader configuration for AVR ~~~~~


SRC_DIRS_ALL += $(SRC_DIR)
SRC_FILES_ALL := $(wildcard $(addsuffix /*.$(SRC_EXTENSION), $(SRC_DIRS_ALL)))
OBJ_FILES_ALL := $(addprefix $(BUILD_DIR)/, $(notdir $(SRC_FILES_ALL:.$(SRC_EXTENSION)=.o)))

TESTS_FILES_ALL := $(wildcard $(addsuffix /*.$(SRC_EXTENSION), $(TESTS_DIR)))
TESTS_EXES_ALL := $(addprefix $(TESTS_DIR)/, $(notdir $(TESTS_FILES_ALL:.$(SRC_EXTENSION)=.exe)))

# Individual flagging -----
STATIC_LIBRARIES_DIRS_ALL_F := $(addprefix -L, $(STATIC_LIBRARIES_DIRS_ALL))
STATIC_LIBRARIES_NAMES_ALL_F := $(addprefix -l, $(STATIC_LIBRARIES_NAMES_ALL))
INCLUDE_DIRS_ALL_F := -I$(INCLUDE_DIR) $(addprefix -I, $(SRC_DIRS_ALL)) $(addprefix -I, $(STATIC_LIBRARIES_INCLUDE_DIRS_ALL))
# Individual flagging ~~~~~


VPATH = $(SRC_DIRS_ALL) $(TESTS_DIR)

DIVIDER := ---------------------------------------------------------------------
# LOGIC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 4. RULES ----------------------------------------------------------
ifeq ($(PROJECT_TYPE), executable)
default: $(BIN_DIR)/$(TARGET).$(EXE_EXTENSION)
else ifeq ($(PROJECT_TYPE), staticLibrary)
default: $(LIB_DIR)/lib$(TARGET).a
endif # if project_type


init:
	@echo Initializing folder structure...
	$(MKDIR) "$(BUILD_DIR)"
	$(MKDIR) "$(DEPS_DIR)"
	$(MKDIR) "$(SRC_DIR)"
	$(MKDIR) "$(DOCS_DIR)"
	$(MKDIR) "$(TESTS_DIR)"
ifeq ($(PROJECT_TYPE), executable)
	$(MKDIR) "$(BIN_DIR)"
else ifeq ($(PROJECT_TYPE), staticLibrary)
	$(MKDIR) "$(INLCUDE_DIR)"
	$(MKDIR) "$(LIB_DIR)"
	$(MKDIR) "$(EXAMPLES_DIR)"
endif
	@echo $(DIVIDER)


ifeq ($(PROJECT_TYPE), executable)
ifeq ($(TARGET_ARCHITECTURE), AVR)
else
run: $(BIN_DIR)/$(TARGET).$(EXE_EXTENSION)
	@echo Running '$<'...
	$(BIN_DIR)/$(TARGET).$(EXE_EXTENSION)
	@echo $(DIVIDER)
endif
endif


debug:
	@echo SRC_FILES_ALL: $(SRC_FILES_ALL)
	@echo OBJ_FILES_ALL: $(OBJ_FILES_ALL)
	@echo TESTS_FILES_ALL: $(TESTS_FILES_ALL)
	@echo TESTS_EXES_ALL: $(TESTS_EXES_ALL)
	@echo TESTS_DIR: $(TESTS_DIR)
	@echo STATIC_LIBRARY_1_INCLUDE_DIR: $(STATIC_LIBRARY_1_INCLUDE_DIR)


all: default tests docs


# AVR upload and format converting rules -----
ifeq ($(TARGET_ARCHITECTURE), AVR)
# Rules for programming AVR ---
program: program_flash

program_flash: $(BIN_DIR)/$(TARGET).hex
	@echo Writing '$<' to AVR's flash...
	$(UPLOADER) $(UPLOADER_OPTIONS) $(UPLOADER_OPTIONS_FLASH)
	@echo $(DIVIDER)

download_flash:
	@echo Reading AVR's flash...
	$(UPLOADER) $(UPLOADER_OPTIONS) $(UPLOADER_OPTIONS_FLASH_DOWNLOAD)
	@echo $(DIVIDER)

program_eeprom: $(BIN_DIR)/$(TARGET).eep
	@echo Writing '$<' to AVR's EEPROM...
	$(UPLOADER) $(UPLOADER_OPTIONS) $(UPLOADER_OPTIONS_EEPROM)
	@echo $(DIVIDER)

download_eeprom:
	@echo Reading AVR's EEPROM...
	$(UPLOADER) $(UPLOADER_OPTIONS) $(UPLOADER_OPTIONS_EEPROM_DOWNLOAD)
	@echo $(DIVIDER)

program_fuses:
	@echo Writing AVR's fuses...
	$(UPLOADER) $(UPLOADER_OPTIONS) $(UPLOADER_OPTIONS_FUSES)
	@echo $(DIVIDER)

download_fuses:
	@echo Reading AVR's fuses...
	$(UPLOADER) $(UPLOADER_OPTIONS) $(UPLOADER_OPTIONS_FUSES_DOWNLOAD)
	@echo $(DIVIDER)
# Rules for programming AVR ~~~

# Rules for converting to hex (AVR) ---
$(BIN_DIR)/$(TARGET).hex: $(BIN_DIR)/$(TARGET).$(EXE_EXTENSION)
	@echo Converting '$<' to '$@'...
	$(OBJCOPY) -O $(FORMAT) $(TEXT_OPTIONS) $< $@
	@echo $(DIVIDER)
	@echo Size:
	$(SIZE) $<
	@echo $(DIVIDER)

$(BIN_DIR)/$(TARGET).eep: $(BIN_DIR)/$(TARGET).$(EXE_EXTENSION)
	@echo Converting '$<' to '$@'...
	$(OBJCOPY) -O $(FORMAT) $(EEPROM_OPTIONS) $< $@
	@echo $(DIVIDER)
	@echo Size:
	$(SIZE) $<
	@echo $(DIVIDER)
# Rules for converting to hex (AVR) ~~~
endif
# AVR upload and format converting rules ~~~~~


# Extract information from the linked object.
ObjectDump: $(BIN_DIR)/$(TARGET).lss
$(BIN_DIR)/$(TARGET).lss: $(BIN_DIR)/$(TARGET).$(EXE_EXTENSION)
	@echo Extracting information from '$<' to '$@'...
	$(OBJDUMP) -h -S $< > $@
	@echo $(DIVIDER)

# Extract symbol table from the linked object.
SymbolTable: $(BIN_DIR)/$(TARGET).sym
$(BIN_DIR)/$(TARGET).sym: $(BIN_DIR)/$(TARGET).$(EXE_EXTENSION)
	@echo Extracting symbol table from '$<' to '$@'...
	$(NM) -n $< > $@
	@echo $(DIVIDER)


# Link
$(BIN_DIR)/$(TARGET).$(EXE_EXTENSION): $(OBJ_FILES_ALL)
	@echo Linking executable '$@'...
	$(LD) $(LD_FLAGS) $^ \
	  $(STATIC_LIBRARIES_DIRS_ALL_F) $(STATIC_LIBRARIES_NAMES_ALL_F) -o $@
	@echo $(DIVIDER)


# Create library archive
ifeq ($(PROJECT_TYPE), staticLibrary)
$(LIB_DIR)/lib$(TARGET).a: $(OBJ_FILES_ALL)
	@echo Creating archive '$@' from object files...
	$(AR) $(AR_FLAGS) $@ $^
	@echo $(DIVIDER)
endif


# All object files
$(BUILD_DIR)/%.$(OBJ_EXTENSION): %.$(SRC_EXTENSION)
	@echo Building object '$@'...
	$(CC) -c $(CC_FLAGS) $(INCLUDE_DIRS_ALL_F) $< -o $@
	@echo $(DIVIDER)


# Static libraries -----
deps: $(STATIC_LIBRARIES_NAMES_ALL)

# USER_CONFIG_STATIC_LIBS - Manually add a rule for every static library.

# $(STATIC_LIBRARY_1_NAME):
# 	@echo Making static library '$@'...
# 	$(MAKE) -C $(STATIC_LIBRARY_1_BASE_DIR)
# 	@echo $(DIVIDER)
# Static libraries ~~~~~


# Tests -----
tests: $(TESTS_EXES_ALL)

# All tests files
ifeq ($(PROJECT_TYPE), executable)
$(TESTS_DIR)/%.$(EXE_EXTENSION): %.$(SRC_EXTENSION) $(OBJ_FILES_ALL)
	@echo Building test '$@'...
	$(LD) $(filter-out $(LD_MAP_OPTION), $(LD_FLAGS)) \
	  $(filter-out $(BUILD_DIR)/$(TARGET).$(OBJ_EXTENSION), $^) \
	  $(STATIC_LIBRARIES_DIRS_ALL_F) $(STATIC_LIBRARIES_NAMES_ALL_F) \
	  -I$(BOOST_DIR) -o $@
	$@
	@echo $(DIVIDER)

else ifeq ($(PROJECT_TYPE), staticLibrary)
$(TESTS_DIR)/%.$(EXE_EXTENSION): $(TESTS_DIR)/%.$(SRC_EXTENSION) $(LIB_DIR)/lib$(TARGET).a
	@echo Building test '$@'...
	$(LD) $(filter-out $(LD_MAP_OPTION), $(LD_FLAGS)) \
	  $(filter-out $(LIB_DIR)/lib$(TARGET).a, $^)  \
	  $(STATIC_LIBRARIES_DIRS_ALL_F) $(STATIC_LIBRARIES_NAMES_ALL_F) \
	  -I$(BOOST_DIR) -l$(TARGET) -o $@
	$@
	@echo $(DIVIDER)
endif
# Tests ~~~~~


# Documentation -----
docs:
ifeq ($(GENERATE_DOCUMENTATION), TRUE)
	@echo Generating documentation...
	cd $(DOCS_DIR)/$(DOC_TOOL_SUBFOLDER) && $(DOC_TOOL) $(DOC_CONFIG_FILE)
	@echo $(DIVIDER)
else
	@echo Skipping generation of documentation, because it is disabled.
endif
# Documentation ~~~~~


clean:
	@echo Cleaning generated project files...
	$(RM) $(BIN_DIR)/*.$(EXE_EXTENSION) \
	  $(BIN_DIR)/*.hex $(BIN_DIR)/*.elf \
	  $(BIN_DIR)/*.eep $(BIN_DIR)/*.map $(BIN_DIR)/*.lss \
	  $(BIN_DIR)/*.sym \
	  $(BUILD_DIR)/*.$(OBJ_EXTENSION) $(BUILD_DIR)/*.map \
	  $(BUILD_DIR)/*.lst $(BUILD_DIR)/*.d $(BUILD_DIR)/*.i \
	  $(BUILD_DIR)/*.ii $(BUILD_DIR)/*.s \
	  $(LIB_DIR_DEFAULT)/*.a \
	  $(TESTS_DIR)/*.$(EXE_EXTENSION)
	@echo $(DIVIDER)

clean_all: clean
	@echo Cleaning dependencies...
	# $(MAKE) -C $(STATIC_LIBRARY_1_BASE_DIR) clean
	@echo $(DIVIDER)

# USER_CONFIG_STATIC_LIBS - Manually add a rule for every static library.

# clean_$(STATIC_LIBRARY_1_NAME):
# 	@echo Cleaning '$(STATIC_LIBRARY_1_NAME)'...
# 	$(MAKE) -C $(STATIC_LIBRARY_1_BASE_DIR) clean
# 	@echo $(DIVIDER)


.PHONY: run clean clean_all docs debug tests deps \
		program program_flash download_flash program_eeprom \
		download_eeprom program_fuses download_fuses

# RULES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# includes generated *.d files (adds dependency for with header files)
-include $(OBJ_FILES_ALL:.o=.d) # (must use -MMD flag when compiling)
