## build

```bash
    mkdir out
    cd out
    cmake -GNinja -DCMAKE_TOOLCHAIN_FILE=../../cmake/stm32.cmake ..
    make upload
```