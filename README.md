# assembly

Assembly playground.

## 6502

You can find some useful resource below:

- [ISA](http://www.6502.org/tutorials/6502opcodes.html#IFLAG)
- [Tutorials](https://skilldrick.github.io/easy6502/#registers)

To run this samples is required Python.

1. Install [necroassembler](https://github.com/rdeioris/necroassembler) by [@rdeioris](https://github.com/rdeioris)

```
$ pip install necroassembler
```

2. To assemble your program:

```
./necro_6502 <src> <dst>
```

3. Install the latest release of [dummy6502](https://github.com/rdeioris/dummy6502) and click `load the rom` to load your assembled code.
