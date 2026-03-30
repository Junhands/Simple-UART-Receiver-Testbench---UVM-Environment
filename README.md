# UART Verification Environment using UVM

This repository contains a robust **Design Verification (DV)** environment for a **Serial Peripheral Interface (UART)** module. The project was developed as part of the curriculum at the **University of Information Technology (UIT)** in collaboration with **Tresemi**.

---

## 🚀 Project Overview
The goal of this project is to verify the functionality and protocol compliance of an UART core using the **Universal Verification Methodology (UVM)**. This environment utilizes constrained-random stimulus, functional coverage, and automated scoreboarding to ensure the design meets its specifications.

## 🛠 Technical Stack
* **Language:** SystemVerilog
* **Methodology:** UVM 1.2 | 1.1d
* **Simulator:** Compatible with Siemens QuestaSim / Cadence Xcelium
* **Protocol:** UART (Supports configurable CPOL and CPHA)

## 🏗 Testbench Architecture
The verification environment follows the standard UVM hierarchy:
* **Top:** Connects the DUT with the UVM Interface.
* **Test:** Defines the test scenarios.
* **Environment:** Encapsulates Agents, Scoreboards, and Virtual Sequencers.
* **Agent:** Contains the Sequencer, Driver, and Monitor for the UART interface.
* **Scoreboard:** Performs data integrity checks by comparing RTL output against a reference model.
* **Functional Coverage:** Ensures all UART configurations and corner cases are exercised.
