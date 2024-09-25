----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: alu
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Performs arithmetic and logic operations on two operands.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY alu IS
    PORT(
        op1 : IN reg32;
        op2 : IN reg32;
        sel : IN inst_type_t;
        zero : OUT STD_LOGIC;
        res : OUT reg32
    );
END alu;

ARCHITECTURE behavioral OF alu IS
    CONSTANT CONST_ZERO : reg32 := (OTHERS => '0');
    
    SIGNAL Q : reg32;
BEGIN
    res <= Q;
    
    WITH sel SELECT
        Q <=    (reg32(sreg32(op1) - sreg32(op2)))  WHEN SUBU,
                (op1 AND op2)                       WHEN AAND,
                (op1 OR op2)                        WHEN OOR | ORI,
                (op1 XOR op2)                       WHEN XXOR,
                (op1 NOR op2)                       WHEN NNOR,
                (reg32(sreg32(op1) + sreg32(op2)))  WHEN OTHERS;
	
	zero <= '1' WHEN (Q = CONST_ZERO) ELSE '0';
END ARCHITECTURE;
