----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: control_unit
-- Project Name: MIPS-V0
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The control part of the processor.
-- 
-- Dependencies: generic_register
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY control_unit IS
    PORT ( 
        instruction : IN reg32;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        zero : IN STD_LOGIC;
        carry : IN STD_LOGIC;
        uins : OUT instruction_t;
        i_address : OUT reg32
    );
END control_unit;

ARCHITECTURE behavioral OF control_unit IS
    SIGNAL incpc : reg32;
    SIGNAL pcmux : sreg32;
    SIGNAL pc : reg32;
    SIGNAL i : inst_type_t;
BEGIN
    PC_REG: ENTITY WORK.generic_register 
    GENERIC MAP(INIT_VALUE => x"00400000")
    PORT MAP(
        D => incpc,
        ce => '1', 
        clk => clk, 
        rst => rst, 
        Q => pc
    );
    
    pcmux <= (RESIZE(sreg32(instruction(25 DOWNTO 0)), 32)) WHEN (
                 (i = B) OR
                 (i = BEQ AND zero = '1' AND carry = '0') OR 
                 (i = BLT AND zero = '0' AND carry = '1') OR 
                 (i = BGT AND zero = '0' AND carry = '0')
             ) ELSE (x"00000004");
    
    incpc <= reg32(sreg32(pc) + pcmux);
    i_address <= pc;
    
    -- Instruction Decoder
    uins.i <= i;  
    i <= PSH    WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000001010" ELSE
         POP    WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000001011" ELSE
         CMP    WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100000" ELSE
         ADDU   WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100001" ELSE
         SUBU   WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100011" ELSE
         AAND   WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100100" ELSE
         OOR    WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100101" ELSE
         XXOR   WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100110" ELSE
         NNOR   WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000100111" ELSE
         RROR   WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000101000" ELSE
         RROL   WHEN instruction(31 DOWNTO 26) = "000000" AND instruction(10 DOWNTO 0) = "00000101001" ELSE     
         ORI    WHEN instruction(31 DOWNTO 26) = "001101" ELSE
         SHRI   WHEN instruction(31 DOWNTO 26) = "001110" ELSE
         SHLI   WHEN instruction(31 DOWNTO 26) = "001111" ELSE
         LW     WHEN instruction(31 DOWNTO 26) = "100011" ELSE
         SW     WHEN instruction(31 DOWNTO 26) = "101011" ELSE
         B      WHEN instruction(31 DOWNTO 26) = "000010" ELSE
         BEQ    WHEN instruction(31 DOWNTO 26) = "000011" ELSE
         BLT    WHEN instruction(31 DOWNTO 26) = "000100" ELSE
         BGT    WHEN instruction(31 DOWNTO 26) = "000101" ELSE
         INVALID;
     
    -- In case of exception
    ASSERT i /= INVALID
          REPORT "INVALID INSTRUCTION"
          SEVERITY ERROR;
          
   -- Main Control Signals
   uins.ce <= '1' WHEN (i = SW OR i = LW OR i = PSH OR i = POP) ELSE '0';
   uins.rw <= '1' WHEN (i = LW OR i = POP) ELSE '0';
   uins.wreg <= '1' WHEN (i /= SW AND i /= PSH AND i /= CMP AND i /= B AND i /= BEQ AND i /= BLT AND i /= BGT) ELSE '0';
END behavioral;
