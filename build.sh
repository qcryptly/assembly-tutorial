#!/bin/bash
gcc -c echo.s -o echo.o
ld -T default.lds echo.o -o echo # you can use ld -verbose your-file
                          # to print the linker script used