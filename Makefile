# CHGame libretro core: standard libretro Makefile (make platform=<p>).
# The zig build (./build.sh) is separate and unchanged.
STATIC_LINKING := 0
TARGET_NAME    := chgame
DEBUG          ?= 0
CORE_DIR       := .

ifeq ($(platform),)
platform = unix
ifeq ($(shell uname -s),)
   platform = win
else ifneq ($(findstring Darwin,$(shell uname -s)),)
   platform = osx
else ifneq ($(findstring MINGW,$(shell uname -s)),)
   platform = win
else ifneq ($(findstring MSYS,$(shell uname -s)),)
   platform = win
endif
endif

CC ?= gcc
fpic :=

ifneq (,$(findstring unix,$(platform)))
   TARGET := $(TARGET_NAME)_libretro.so
   fpic := -fPIC
   SHARED := -shared -Wl,--no-undefined -Wl,--version-script=$(CORE_DIR)/libretro/link.T
   LDFLAGS += -lm
else ifneq (,$(findstring linux,$(platform)))
   TARGET := $(TARGET_NAME)_libretro.so
   fpic := -fPIC
   SHARED := -shared -Wl,--no-undefined -Wl,--version-script=$(CORE_DIR)/libretro/link.T
   LDFLAGS += -lm
else ifneq (,$(findstring osx,$(platform)))
   TARGET := $(TARGET_NAME)_libretro.dylib
   fpic := -fPIC
   SHARED := -dynamiclib
   ifeq ($(CROSS_COMPILE),1)
      TARGET_RULE   = -target $(LIBRETRO_APPLE_PLATFORM) -isysroot $(LIBRETRO_APPLE_ISYSROOT)
      CFLAGS       += $(TARGET_RULE)
      LDFLAGS      += $(TARGET_RULE)
   endif
else ifneq (,$(findstring win,$(platform)))
   TARGET := $(TARGET_NAME)_libretro.dll
   CC = gcc
   SHARED := -shared -static-libgcc -static -s
   LDFLAGS += -lm
else ifneq (,$(findstring emscripten,$(platform)))
   TARGET := $(TARGET_NAME)_libretro_emscripten.bc
   CC = emcc
   STATIC_LINKING = 1
else
   # other platforms: generic shared object
   TARGET := $(TARGET_NAME)_libretro.so
   fpic := -fPIC
   SHARED := -shared
   LDFLAGS += -lm
endif

include Makefile.common

OBJECTS := $(SOURCES_C:.c=.o)

ifeq ($(DEBUG),1)
   CFLAGS += -O0 -g
else
   CFLAGS += -O3
endif

CFLAGS += -std=gnu99 -Wall -Wno-unused-parameter $(fpic) $(INCFLAGS) $(COREDEFINES)

all: $(TARGET)

$(TARGET): $(OBJECTS)
ifeq ($(STATIC_LINKING), 1)
	$(AR) rcs $@ $(OBJECTS)
else
	$(CC) $(fpic) $(SHARED) -o $@ $(OBJECTS) $(LDFLAGS)
endif

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJECTS) $(TARGET_NAME)_libretro.so $(TARGET_NAME)_libretro.dylib \
	      $(TARGET_NAME)_libretro.dll $(TARGET_NAME)_libretro_emscripten.bc

.PHONY: all clean
