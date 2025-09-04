# nRF51 RBPCONF Bypass firmware dumper

Proof-of-concept script to bypass **RBPCONF (Readback Protection)** on nRF51 MCUs and dump protected flash firmware over SWD.

This repo contains:
- A Python wrapper (`nrf51_dump.py`) to run the process and parse results.
- A GDB script (`dumper.gdb`) that automatically locates a usable load instruction and abuses it to read protected flash memory.

> ⚠️ For educational and research purposes only. Do not use against hardware you don’t own or have explicit permission to test.

---

## How it works

The highest protection available on nRF51 devices allows for SWD connections but no flash reads.By forcing register states and single-stepping the CPU, we hijack a load instruction in CR0 and abuse it to read arbitrary words from flash.
Dumped words are logged to a file, parsed, and reassembled into a binary firmware image.

For a detailed walkthrough of the vulnerability, see the related blog post at: [https://lessonsec.com/posts/nrf51-bypass/]([https://yourbloglink](https://lessonsec.com/posts/nrf51-bypass/).

---

## Requirements

**Hardware**
- nRF51 target (e.g. nRF51822 dev board)
- SWD debugger (tested with J-Link via OpenOCD)

**Software**
- [OpenOCD](https://openocd.org/)
- `arm-none-eabi-gdb`
- Python 3.x

---

## Usage

1. Connect the target via SWD (VCC, GND, SWDIO, SWDCLK).
2. Start OpenOCD with:

   ```bash
   openocd -f interface/jlink.cfg -c "transport select swd" -f target/nrf51.cfg
   ```
   Or adapt the command to user your favourite debugger.

3. In another terminal, run the Python wrapper:
   ```bash
   python3 nrf51_dump.py
   ```
4. Wait for the process to complete (can take ~1 hour for 256kB flash).
   You should see file `firmware.bin` available.
