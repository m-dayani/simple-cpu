----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:01:05 11/06/2017 
-- Design Name: 
-- Module Name:    CPU_FORUTAN1669V1 - Behavioral 
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

entity CPU_FORUTAN1696V1 is
    Port ( 
			  MEM_DB : inout  STD_LOGIC_VECTOR (15 downto 0);
           RF_INPUT : in  STD_LOGIC_VECTOR (15 downto 0);
			  CLK : in  STD_LOGIC;
			  
			  ADDR_BUS : out STD_LOGIC_VECTOR (11 downto 0)
			 );
end CPU_FORUTAN1696V1;

architecture Behavioral of CPU_FORUTAN1696V1 is
	component CONTROL_BLOCK is
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
	end component CONTROL_BLOCK;
	component DATA_PATH is
		Port ( 
			  MEM_DB : inout  STD_LOGIC_VECTOR (15 downto 0);
			  RF_LD_CTRL : in  STD_LOGIC_VECTOR (5 downto 0);
			  RF_RD_CTRL : in  STD_LOGIC_VECTOR (5 downto 0);
			  RF_INPUT : in  STD_LOGIC_VECTOR (15 downto 0);
			  RF_INT_OFFSET : in  STD_LOGIC_VECTOR (2 downto 0);
			  SH_CTRL : in  STD_LOGIC_VECTOR (6 downto 0);
			  ALU_OP : in  STD_LOGIC_VECTOR (3 downto 0);
			  F_UPPER : in  STD_LOGIC_VECTOR (3 downto 0);
			  SEL_CTRL : in  STD_LOGIC_VECTOR (5 downto 0);
			  ALU_C_IN : in  STD_LOGIC;
			  IR_LOAD : in  STD_LOGIC;
			  CLK : in  STD_LOGIC;
			  F_2CTRL : out  STD_LOGIC_VECTOR (7 downto 0);		
			  INSTR_OPCODE : out STD_LOGIC_VECTOR (4 downto 0);
			  ADDR_BUS : out STD_LOGIC_VECTOR (11 downto 0)
			 );
	end component DATA_PATH;
	
	signal f_2ctr : STD_LOGIC_VECTOR (7 downto 0);
	signal sh_ctr : STD_LOGIC_VECTOR (6 downto 0);
	signal rf_ld_ctr, rf_rd_ctr, sel_ctr : STD_LOGIC_VECTOR (5 downto 0);
	signal opcode : STD_LOGIC_VECTOR (4 downto 0);
	signal alu_opcode, f_up : STD_LOGIC_VECTOR (3 downto 0);
	signal int_offset : STD_LOGIC_VECTOR (2 downto 0);
	signal c_in, ir_ld : STD_LOGIC;
begin
	CPU_DP: DATA_PATH port map (MEM_DB => MEM_DB, RF_LD_CTRL => rf_ld_ctr, RF_RD_CTRL => rf_rd_ctr,
											RF_INPUT => RF_INPUT, RF_INT_OFFSET => int_offset, SH_CTRL => sh_ctr,
											ALU_OP => alu_opcode, F_UPPER => f_up, SEL_CTRL => sel_ctr, ALU_C_IN => c_in,
											IR_LOAD => ir_ld, CLK => CLK, F_2CTRL => f_2ctr, INSTR_OPCODE => opcode,
											ADDR_BUS => ADDR_BUS);
	CPU_CTRL: CONTROL_BLOCK port map (INSTR_OPCODE => opcode, F_2CTRL => f_2ctr, CLK => CLK, IR_LOAD => ir_ld,
											RF_RD_CTRL => rf_rd_ctr, RF_LD_CTRL => rf_ld_ctr, SEL_CTRL => sel_ctr,
											F_UPPER => f_up, RF_INT_OFFSET => int_offset, SH_CTRL => sh_ctr, ALU_OP => alu_opcode,
											ALU_C_IN => c_in);
end Behavioral;

