# Basic ARM-CPU
 
 You can find all the information about this CPU and it's main module codes in the 7th chapter of the book "Digital Design and Computer Architecture: ARM Edition" by Sarah L. Harris (Author), David Harris  (Author).
 
# Directory Structure
```
├── Benchmarks                 # contains the test codes for the 3 versions of the CPU
    ├── BM V1
    ├── BM V2
    └── BM V3
├── Design CPU V1              # first CPU version (no pipeline, no hazard unit control)
    ├── Hex BM
    ├── Module Sources
    └── Simulation Sources
├── Design CPU V2              # second CPU version (with pipeline, no hazard unit control)
    ├── Hex BM
    ├── Module Sources
    └── Simulation Sources
├── Design CPU V3              # third CPU version (with pipeline and with hazard unit control)
    ├── Hex BM
    ├── Module Sources
    └── Simulation Sources
└── README.md
```

# Quickstart guide

1. Clone the repository
2. Open Vivado
3. Create a new project with the board "XC7A100TCSG324-1"
4. Add the modules, `add sources -> add or create design sources -> add Directories` select the `Module Sources` from the version you want to use then `finish`
5. Add the test bench, `add sources -> add or create simulation sources -> add Directories` select the `Simulation Sources` from the same version you used before, then `finish`
6. Add the Hex BenchMark, `add sources -> add or create design sources -> add Files`select the file `.mem` from the same version you used before, then `finish`
7. Now you are ready to Run Simulation or Synthesis
