LOCAL_PATH := $(call my-dir)
CORE_DIR   := $(LOCAL_PATH)/..

include $(CORE_DIR)/Makefile.common

include $(CLEAR_VARS)
LOCAL_MODULE    := retro
LOCAL_SRC_FILES := $(SOURCES_C)
LOCAL_C_INCLUDES := $(EMU_DIR) $(LIBRETRO_DIR)
LOCAL_CFLAGS    := -std=gnu99 -O3 -Wall -Wno-unused-parameter  $(COREDEFINES)
LOCAL_LDFLAGS   := -Wl,-version-script=$(CORE_DIR)/libretro/link.T
LOCAL_LDLIBS    := -lm
include $(BUILD_SHARED_LIBRARY)
