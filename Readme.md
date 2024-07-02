# Benchmark and Energy Consumption Data Collection

## Overview

This repository contains benchmarks, data collection scripts, and utilities for benchmarking and measuring energy consumption using different tools.

### Folders

#### Benchmarks

Contains various benchmarks from the Rodinia suite, each with modified makefiles for compilation using GCC, Clang, and ICC compilers. After compilation, each benchmark's executable should be moved to the `benchmarks_compiled` folder.

#### Benchmarks_Compiled

After compiling the benchmarks from the `Benchmarks` folder, the executables are stored here.

#### Data

Contains pre-collected data related to the `myocyte` benchmark.

#### Scripts

- **PerfPowerTracker**

  Script for collecting benchmarking data using `perf`, capturing metrics such as duration, energy consumed (package, DRAM, cores, GPU), and exit codes.

- **JouleIT**

  Script for data collection using RAPL (Running Average Power Limit).

- **CollectData (Auxiliary Script)**

  An auxiliary script to facilitate data collection from benchmarks using `PerfPowerTracker`. To collect data from other benchmarks, modify the executable and its respective parameters and iterations within this script.

### Usage

1. **Compiling Benchmarks**

   Navigate to the `Benchmarks` folder and compile benchmarks using appropriate makefiles for GCC, Clang, or ICC.

   ```bash
   cd Benchmarks
   make -f Makefile.gcc      # Example for GCC
   make -f Makefile.clang    # Example for Clang
   make -f Makefile.icc      # Example for ICC
   ```

   After compilation, move the generated executables to `Benchmarks_Compiled`.

2. **Data Collection**

   - **Using PerfPowerTracker:**
     
     Ensure that `perf` is installed and accessible with appropriate permissions (may require `sudo`). Adjust parameters in the script as needed for different benchmarks.

     ```bash
     ./Scripts/PerfPowerTracker <benchmark_executable> <parameters...>
     ```

   - **Using JouleIT:**
     
     Run the script directly to collect data using RAPL.

     ```bash
     ./Scripts/JouleIT
     ```

   - **Using CollectData (Auxiliary Script):**
     
     Modify the script `CollectData` to specify the benchmark executable and its parameters for data collection.

     ```bash
     ./Scripts/CollectData
     ```

   Ensure all necessary dependencies are installed and scripts have executable permissions (`chmod +x script_name.sh`) before use.
