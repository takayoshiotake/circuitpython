USB_VID = 0x1209
USB_PID = 0x3252
USB_PRODUCT = "Targett Module Clip w/Wroom"
USB_MANUFACTURER = "Targett"

IDF_TARGET = esp32s2

INTERNAL_FLASH_FILESYSTEM = 1
LONGINT_IMPL = MPZ

# The default queue depth of 16 overflows on release builds,
# so increase it to 32.
CFLAGS += -DCFG_TUD_TASK_QUEUE_SZ=32

CIRCUITPY_ESP_FLASH_MODE = dio
CIRCUITPY_ESP_FLASH_FREQ = 40m
CIRCUITPY_ESP_FLASH_SIZE = 4MB
