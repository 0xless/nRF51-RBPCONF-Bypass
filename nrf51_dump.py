#!/usr/bin/env python3
import subprocess
import struct

# GDB target
gdb_target = "localhost:3333"  # OpenOCD GDB server
output_bin = "firmware.bin"
ARM_GDB_PATH = "arm-none-eabi-gdb"

# Temporary GDB script to generate
gdb_script_file = "dumper.gdb"

# Run GDB in batch mode with the generated script
subprocess.run([ARM_GDB_PATH, "-batch", "-x", gdb_script_file])

# Parse r0_dump.txt and write binary firmware
with open("r0_dump.txt", "r") as f_in, open(output_bin, "wb") as f_out:
    for line in f_in:
        line = line.strip()
        if not line:
            continue
        if "in ??" in line:   # skip disassembly/PC info
            continue

        try:
            val = int(line, 16)
            f_out.write(struct.pack("<I", val))  # little-endian
        except:
            pass

print(f"Firmware written to {output_bin}")
