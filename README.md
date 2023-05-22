# Keystone App Template
Template for Keystone Enclave Application

## Pre-requisite
- Keystone SDK installed & set `KEYSTONE_SDK_DIR`
- RISC-V GNU ToolChain
  - Compatible version is gcc 10.2.0
    - Download pre-built binary [here](https://keystone-enclave.eecs.berkeley.edu/files/riscv-toolchain-lp64d-rv64gc-2021.01.bionic.7z)
  - Cannot build with latest gnu libc and musl libc now (2023.05)

## Usage
- Clone
```
git clone https://github.com/Nanamiiiii/keystone-app-template.git <project_name>
```

- Setup runtime
  - Use setup script
    ```
    ./setup_runtime.sh
    ```
  - Use existing runtime source
    ```
    export RUNTIME_SRC=<runtime_dir>
    ```

- Modify `CMakeLists.txt`
  - Modify the sections indicated by `### NEED TO MODIFY ###` to fit your project.

## Build
```
mkdir build && cd build
cmake ..

# build individual binary
make

# build self-extract package (makeself)
# the package is named "<project_name>.ke" 
make package
```

