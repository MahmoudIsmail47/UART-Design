# UART Transmitter and Receiver Design using Verilog HDL

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 📜 Overview

This project implements a complete **UART (Universal Asynchronous Receiver/Transmitter)** protocol system using Verilog HDL. It includes three main modules:

- **UART Transmitter (TX):** Converts 8-bit parallel data to serial format with optional parity.
- **UART Receiver (RX):** Converts serial data back to parallel, verifies parity and stop bits.
- **Oversampling Clock Generator:** Ensures TX clock is 6× RX clock when required.

Simulation is performed using **ModelSim**, and synthesis/implementation is done using **Vivado** targeting FPGA platforms.

---

## 🧠 Features

### 🔄 Transmitter
- Supports **even**, **odd**, and **no parity**
- Custom **prescale control** to adjust TX clock
- Status signal `busy` indicates transmission activity
- TX frame format:
  - Parity enabled: `Start (0)` + `8-bit data` + `Parity bit` + `Stop (1)`
  - Parity disabled: `Start (0)` + `8-bit data` + `Stop (1)`

### 📥 Receiver
- Checks **start**, **parity**, and **stop** bits
- Outputs `data_valid`, `parity_error`, and `stop_error`
- Stores received 8-bit data
- Supports parity modes (odd/even/none)

### ⏱️ Oversampling Clock
- Doubles TX clock speed based on `prescale` signal
- Allows TX to run at 6× frequency of RX

---
For details check the report here: https://drive.google.com/drive/folders/1ghuPftl55EcqMfrmjX1ApxRFeS1TBQ6X?fbclid=IwAR1TijX9QFM21MrZ6TGsVVuSFAcw9kS2024g5At9Y1cFVco3V1VChGA6P8Q
