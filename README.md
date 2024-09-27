# MIPS-V0
A simplified MIPS processor made in VHDL for the "Digital Systems" course. The diagram of the version 1 of the processor can be seen bellow:

![image](https://github.com/botelhocpp/MIPS-V0/blob/version3/docs/diagram.png)

## Instructions Supported

Instructions selected, by the professor Thiago Bandeira, to be implemented in the processor.

|      | Type | Opcode | Shamt/Function |
|:----:|:----:|:------:|:--------------:|
|  CMP |   R  | 000000 |   00000100000  |
| ADDU |   R  | 000000 |   00000100001  |
| SUBU |   R  | 000000 |   00000100011  |
| AAND |   R  | 000000 |   00000100100  |
|  OOR |   R  | 000000 |   00000100101  |
| XXOR |   R  | 000000 |   00000100110  |
| NNOR |   R  | 000000 |   00000100111  |
| RROR |   R  | 000000 |   00000101000  |
| RROL |   R  | 000000 |   00000101001  |
|  PSH |   R  | 000110 |   00000000000  |
|  POP |   R  | 000111 |   00000000000  |
|  ORI |   I  | 001101 |        -       |
| SHRI |   I  | 001110 |        -       |
| SHLI |   I  | 001111 |        -       |
|  LW  |   I  | 100011 |        -       |
|  SW  |   I  | 101011 |        -       |
|   B  |   J  | 000010 |        -       |
|  BEQ |   J  | 000011 |        -       |
|  BLT |   J  | 000100 |        -       |
|  BGT |   J  | 000101 |        -       |
