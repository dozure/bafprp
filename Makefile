CPP = /usr/bin/gcc
BINARY = bafprp

UNAME_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')

SOURCE_DIR = src
BIN_DIR = bin
BUILD_DIR = build

INCLUDE = -Iinclude
LDFLAGS=-lodbc -lstdc++

OPT_FLAGS = -O3 -pipe -s -funroll-loops -fno-rtti
DEBUG_FLAGS = -g -ggdb3

ifeq ($(UNAME_S), SunOS)
        LDFLAGS += -lsocket -lnsl
endif

SOURCES = \
bafdefines.cpp \
baffile.cpp \
bafprp.cpp \
base64.cpp \
compat.cpp \
consoleoutput.cpp \
crc32.cpp \
emailoutput.cpp \
fileoutput.cpp \
bafrecord.cpp \
ifield.cpp \
mailer.cpp \
mssqloutput.cpp \
mysqloutput.cpp \
csvoutput.cpp \
nooutput.cpp \
output.cpp \
field_defs.cpp \
date_dt.cpp \
duration_dt.cpp \
shortduration_dt.cpp \
number_dt.cpp \
phonenumber_dt.cpp \
record_defs.cpp \
switch_dt.cpp \
time_dt.cpp \
number_switch_dt.cpp

#
# Do not edit below
#

# The default rule is all (default because its the first rule, making it 'default')
default: all

CFLAGS = $(OPT_FLAGS) -fpermissive -D_LINUX -DNDEBUG -Wno-deprecated
DCFLAGS = $(DEBUG_FLAGS) -v -fpermissive -D_LINUX -D_DEBUG -Wno-deprecated
 
OBJ_LINUX := $(SOURCES:%.cpp=$(BUILD_DIR)/%.o)
DOBJ_LINUX := $(SOURCES:%.cpp=$(BUILD_DIR)/%_d.o)

$(OBJ_LINUX): $(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.cpp
	mkdir -p $(BUILD_DIR)
	$(CPP) $(INCLUDE) $(CFLAGS) -o $@ -c $<

$(DOBJ_LINUX): $(BUILD_DIR)/%_d.o: $(SOURCE_DIR)/%.cpp
	mkdir -p $(BUILD_DIR)
	$(CPP) $(INCLUDE) $(DCFLAGS) -o $@ -c $<

.PHONY: default all clean rebuild release debug install uninstall

all: release debug

rebuild: clean all

release: $(OBJ_LINUX)
	mkdir -p $(BIN_DIR)
	$(CPP) $^ $(LDFLAGS) -s -o $(BIN_DIR)/$(BINARY)

debug: $(DOBJ_LINUX)
	mkdir -p $(BIN_DIR)
	$(CPP) $^ $(LDFLAGS) -o $(BIN_DIR)/$(BINARY)_d

install: release
	cp $(BIN_DIR)/$(BINARY) /usr/bin/$(BINARY)
	mkdir -p /var/log/$(BINARY)

uninstall:
	$(RM) -f /usr/bin/$(BINARY)
	$(RM) -rf /var/log/$(BINARY)

clean:
	$(RM) -rf $(BUILD_DIR)
