# All linking can be done with this common templated linker script, which has
# parameters that vary based on chip and/or board.
LD_TEMPLATE_FILE = boards/common.template.ld

INTERNAL_LIBM = 1

# Number of USB endpoint pairs.
USB_NUM_ENDPOINT_PAIRS = 8

CIRCUITPY_ROTARYIO_SOFTENCODER = 1
CIRCUITPY_OPTIMIZE_PROPERTY_FLASH_SIZE ?= 1
CIRCUITPY_LTO = 1

######################################################################
# Put samd21-only choices here.

ifeq ($(CHIP_FAMILY),samd21)

# The ?='s allow overriding in mpconfigboard.mk.

# Some of these are on by default with CIRCUITPY_FULL_BUILD, but don't
# fit in 256kB of flash

CIRCUITPY_AESIO ?= 0
CIRCUITPY_ATEXIT ?= 0
CIRCUITPY_AUDIOMIXER ?= 0
CIRCUITPY_BINASCII ?= 0
CIRCUITPY_BITBANGIO ?= 0
CIRCUITPY_BITMAPTOOLS ?= 0
CIRCUITPY_BUSDEVICE ?= 0
CIRCUITPY_AUDIOMP3 ?= 0
CIRCUITPY_BLEIO_HCI = 0
CIRCUITPY_BUILTINS_POW3 ?= 0
CIRCUITPY_COMPUTED_GOTO_SAVE_SPACE ?= 1
CIRCUITPY_COUNTIO ?= 0
# Not enough RAM for framebuffers
CIRCUITPY_FRAMEBUFFERIO ?= 0
CIRCUITPY_FREQUENCYIO ?= 0
CIRCUITPY_GETPASS ?= 0
CIRCUITPY_GIFIO ?= 0
CIRCUITPY_I2CPERIPHERAL ?= 0
CIRCUITPY_JSON ?= 0
CIRCUITPY_KEYPAD ?= 0
CIRCUITPY_MSGPACK ?= 0
CIRCUITPY_RE ?= 0
CIRCUITPY_SDCARDIO ?= 0
CIRCUITPY_SYNTHIO ?= 0
CIRCUITPY_TOUCHIO_USE_NATIVE ?= 1
CIRCUITPY_TRACEBACK = 0
CIRCUITPY_ULAB = 0
CIRCUITPY_VECTORIO = 0
CIRCUITPY_ZLIB = 0

# TODO: In CircuitPython 8.0, turn this back on, after `busio.OneWire` is removed.
# We'd like a smoother transition, but we can't afford the space to have both
# `busio.OneWire` and `onewireio.OneWire` present on these tiny builds.

ifeq ($(INTERNAL_FLASH_FILESYSTEM),1)
CIRCUITPY_ONEWIREIO ?= 0
endif

MICROPY_PY_ASYNC_AWAIT = 0

# We don't have room for the fonts for terminalio for certain languages,
# so turn off terminalio, and if it's off and displayio is on,
# force a clean build.
# Note that we cannot test $(CIRCUITPY_DISPLAYIO) directly with an
# ifeq, because it's not set yet.
ifneq (,$(filter $(TRANSLATION),ja ko ru))
CIRCUITPY_TERMINALIO = 0
RELEASE_NEEDS_CLEAN_BUILD = $(CIRCUITPY_DISPLAYIO)
endif

SUPEROPT_GC = 0
SUPEROPT_VM = 0

CIRCUITPY_LTO_PARTITION = one

ifeq ($(CIRCUITPY_FULL_BUILD),0)
# On the smallest boards, this saves about 180 bytes. On other boards, it may -increase- space used.
CFLAGS_BOARD = -fweb -frename-registers
endif

endif # samd21
######################################################################

######################################################################
# Put samd51-only choices here.

ifeq ($(CHIP_FAMILY),samd51)

# No native touchio on SAMD51.
CIRCUITPY_TOUCHIO_USE_NATIVE = 0

ifeq ($(CIRCUITPY_FULL_BUILD),0)
CIRCUITPY_LTO_PARTITION ?= one
endif

# The ?='s allow overriding in mpconfigboard.mk.


CIRCUITPY_ALARM ?= 1
CIRCUITPY_PS2IO ?= 1
CIRCUITPY_SAMD ?= 1
CIRCUITPY_FLOPPYIO ?= $(CIRCUITPY_FULL_BUILD)
CIRCUITPY_FRAMEBUFFERIO ?= $(CIRCUITPY_FULL_BUILD)
CIRCUITPY_RGBMATRIX ?= $(CIRCUITPY_FRAMEBUFFERIO)
CIRCUITPY_WATCHDOG ?= 1

endif # samd51
######################################################################

######################################################################
# Put same51-only choices here.

ifeq ($(CHIP_FAMILY),same51)

# No native touchio on SAME51.
CIRCUITPY_TOUCHIO_USE_NATIVE = 0

ifeq ($(CIRCUITPY_FULL_BUILD),0)
CIRCUITPY_LTO_PARTITION ?= one
endif

# The ?='s allow overriding in mpconfigboard.mk.

CIRCUITPY_ALARM ?= 1
CIRCUITPY_PS2IO ?= 1
CIRCUITPY_SAMD ?= 1
CIRCUITPY_FLOPPYIO ?= $(CIRCUITPY_FULL_BUILD)
CIRCUITPY_FRAMEBUFFERIO ?= $(CIRCUITPY_FULL_BUILD)
CIRCUITPY_RGBMATRIX ?= $(CIRCUITPY_FRAMEBUFFERIO)

endif # same51
######################################################################

CIRCUITPY_BUILD_EXTENSIONS ?= uf2
