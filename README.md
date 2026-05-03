# CompArch-labs

A collection of computer architecture labs demonstrating fundamental concepts in system design through hands-on implementation projects.

## Overview

This repository contains practical labs for studying computer architecture through real implementations:
- VHDL design and register file implementation
- GPU computing and performance optimization
- Benchmarking and performance analysis

## Course Structure

The labs provide hands-on experience with key architectural concepts:

| Lab | Topic | Description |
|-----|-------|-------------|
| Lab 1 | VHDL Register File Design | Implementing register files in hardware description language |
| Lab 2 | GPU Benchmarking | Matrix multiplication optimization on GPU (AxBxC + A for square matrices) |

## Prerequisites

- Basic understanding of digital logic
- Knowledge of C/C++ (for GPU benchmarking and testing)
- Familiarity with command-line tools
- Hardware description language (HDL) knowledge for VLSI lab
- CUDA or OpenCL setup for GPU lab

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/codelink7/CompArch-labs.git
   cd CompArch-labs
   ```

2. Navigate to a specific lab:
   ```bash
   cd Lab1    # For VHDL Register File
   # or
   cd Lab2    # For GPU Benchmarking
   ```

3. Read the lab instructions in the README file within each lab directory

4. Complete the assignment and test your implementation

## Tools & Technologies

- **Languages**: C++, Verilog/VHDL, CUDA
- **Simulators**: ModelSim, Vivado
- **GPU Framework**: CUDA, cuBLAS
- **Build System**: Make, CMake

## Lab Submissions

Each lab folder contains:
- `README.md` - Detailed lab instructions and requirements
- `src/` - Source code directory
- `test/` - Test cases and verification scripts
- `docs/` - Design documentation and reference materials

## Contributing

This is a course repository. For questions or clarifications about the labs, please contact the course instructor.

## License

These materials are provided for educational purposes.

## Additional Resources

- [Computer Organization and Design](https://www.elsevier.com/books/computer-organization-and-design/patterson/5th-edition) - Patterson & Hennessy
- [Digital Design](https://www.pearson.com/en-us/subject-catalog/p/digital-design-morris-mano/9780133756882) - Morris Mano
- NVIDIA CUDA Documentation: https://docs.nvidia.com/cuda/
- RISC-V ISA Documentation: https://riscv.org/

---

**Last Updated**: May 2026
