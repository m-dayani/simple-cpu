----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:08:17 11/06/2017 
-- Design Name: 
-- Module Name:    CONTROL_BLOCK - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTROL_BLOCK is
    Port ( 
			  INSTR_OPCODE : in STD_LOGIC_VECTOR (4 downto 0);
			  F_2CTRL : in  STD_LOGIC_VECTOR (7 downto 0);
			  CLK : in  STD_LOGIC;
			  
			  IR_LOAD : out  STD_LOGIC;
			  RF_RD_CTRL : out  STD_LOGIC_VECTOR (5 downto 0);
			  RF_LD_CTRL : out  STD_LOGIC_VECTOR (5 downto 0);
			  SEL_CTRL : out  STD_LOGIC_VECTOR (5 downto 0);
			  F_UPPER : out  STD_LOGIC_VECTOR (3 downto 0);
			  RF_INT_OFFSET : out  STD_LOGIC_VECTOR (2 downto 0);
			  SH_CTRL : out  STD_LOGIC_VECTOR (6 downto 0);
			  ALU_OP : out  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_C_IN : out  STD_LOGIC
			 );
end CONTROL_BLOCK;

architecture Behavioral of CONTROL_BLOCK is
	signal ctrl : STD_LOGIC_VECTOR (37 downto 0);
begin
	process(INSTR_OPCODE, F_2CTRL, CLK)
	begin
		--if we have mem operation (ld/st) wait for 1 clk
		--else if we have input intrrupt, do something.
		--else if all is good begin decoding instruction
		case INSTR_OPCODE(4 downto 2) is		--switch against op1
			when "000" =>
				ctrl <= "11100001100010000000110000000000010100";
			when others =>		--unknown opcode -> intrrupt_uop
				ctrl <= "11100001100010000000110000000000010100";
		end case;
	end process;
	
	IR_LOAD <= ctrl(37);
	RF_RD_CTRL <= ctrl(36 downto 31);
	RF_LD_CTRL <= ctrl(30 downto 25);
	SEL_CTRL <= ctrl(24 downto 19);
	F_UPPER <= ctrl(18 downto 15);
	RF_INT_OFFSET <= ctrl(14 downto 12);
	SH_CTRL <= ctrl(11 downto 5);
	ALU_OP <= ctrl(4 downto 1);
	ALU_C_IN <= ctrl(0);
end Behavioral;

