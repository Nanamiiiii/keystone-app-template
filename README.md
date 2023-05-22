# Keystone App Template
Template for Keystone Enclave Application

## Pre-requisite
- Keystone SDK installed & set `KEYSTONE_SDK_DIR`
- RISC-V GNU ToolChain
  - Compatible version is gcc 10.2.0
    - Download pre-built binary [here](https://keystone-enclave.eecs.berkeley.edu/files/riscv-toolchain-lp64d-rv64gc-2021.01.bionic.7z)
  - Cannot build with latest gnu libc and musl libc now (2023.05)

## Usage
- Download init script
  ```
  wget https://gist.githubusercontent.com/Nanamiiiii/8c2d8c76c8b72157ec02814ed6c3aa7b/raw/4d3bb481c90cd30e6209971cab6dc979ab733836/keinit
  ```

- Create project
  ```
  ./keinit <project_name>
  cd <project_name>
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

