LOCAL_PATH := $(call my-dir)
PERFTEST = 0
HAVE_SHARED_CONTEXT=0
SINGLE_THREAD=0
HAVE_OPENGL=1
GLES = 1
GIT_VERSION = $(shell git describe --abbrev=4 --dirty --always --tags)

include $(CLEAR_VARS)

LOCAL_MODULE := retro

ROOT_DIR := ..
LIBRETRO_DIR = ../libretro

ifeq ($(TARGET_ARCH),arm)
LOCAL_ARM_MODE := arm
LOCAL_CFLAGS := -marm

COMMON_FLAGS := -DANDROID_ARM -DGIT_VERSION=\"$(GIT_VERSION)\"

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
LOCAL_ARM_NEON := true
HAVE_NEON := 1
endif

endif

ifeq ($(TARGET_ARCH),x86)
COMMON_FLAGS := -DANDROID_X86 -D__SSE2__ -D__SSE__ -D__SOFTFP__
endif

ifeq ($(TARGET_ARCH),mips)
COMMON_FLAGS := -DANDROID_MIPS
endif

ifeq ($(NDK_TOOLCHAIN_VERSION), 4.6)
COMMON_FLAGS += -DANDROID_OLD_GCC
endif

SOURCES_C   :=
SOURCES_CXX :=
SOURCES_ASM :=
INCFLAGS    :=

HAVE_OPENGL = 1

include $(ROOT_DIR)/Makefile.common

LOCAL_SRC_FILES := $(SOURCES_CXX) $(SOURCES_C) $(SOURCES_ASM)

# Video Plugins

COMMON_FLAGS += -D__LIBRETRO__ -DINLINE="inline" -DANDROID
COMMON_OPTFLAGS = -O3

LOCAL_CFLAGS += $(COMMON_OPTFLAGS) $(COMMON_FLAGS) -std=gnu99 $(INCFLAGS) $(GLFLAGS)
LOCAL_CXXFLAGS += $(COMMON_OPTFLAGS) $(COMMON_FLAGS) $(INCFLAGS) $(GLFLAGS)
LOCAL_LDLIBS += -lGLESv2
LOCAL_C_INCLUDES = $(INCFLAGS)

ifeq ($(PERFTEST), 1)
LOCAL_CFLAGS += -DPERF_TEST
LOCAL_CXXFLAGS += -DPERF_TEST
endif

include $(BUILD_SHARED_LIBRARY)

