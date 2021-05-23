# Basic ARM-CPU
 
 The main codes for this CPU are from the book "Digital Design and Computer Architecture: ARM Edition" by Sarah L. Harris (Author), David Harris  (Author).
 
# Directory Structure
```
├── Benchmarks                 # contains the test codes for the 3 versions of the CPU
    ├── BM V1
    ├── BM V2
    └── BM V3
├── Design CPU V1              # first CPU version (no pipeline, no hazard unit control)
    ├── SystemVerilog
    └── Hex BM
├── Design CPU V2              # second CPU version (with pipeline, no hazard unit control)
    ├── systemVerilog
    └── Hex BM
├── Design CPU V3              # third CPU version (with pipeline and with hazard unit control)
    ├── systemVerilog
    └── Hex BM
└── README.md
```

# Quickstart guide

1. Clone the repository
2. Open Vivado
3. Create a new project with the board "XC7A100TCSG324-1"
4. In the project go to `add sources -> add or create design sources -> add Directories` select the `Module Sources` from the version you want to use then `finish`
5. 
