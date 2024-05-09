----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:50:04 11/03/2017 
-- Design Name: 
-- Module Name:    DATA_PATH - Behavioral 
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

entity DATA_PATH is
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
end DATA_PATH;

architecture Behavioral of DATA_PATH is
	component Reg_16bit is
		Port ( D_in : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (15 downto 0);
           LOAD : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
	end component Reg_16bit;
	component REG_FILE_ALL is
		Port ( RD_N1 : in  STD_LOGIC_VECTOR (2 downto 0);
           RD_N2 : in  STD_LOGIC_VECTOR (2 downto 0);
           LD_CTRL : in  STD_LOGIC_VECTOR (5 downto 0);
			  RD_CTRL : in  STD_LOGIC_VECTOR (5 downto 0);
           WR_D : in  STD_LOGIC_VECTOR (15 downto 0);		--from alu or mem_db
			  D_IN : in  STD_LOGIC_VECTOR (15 downto 0);		--from input switch
			  IMMEDIATE : in  STD_LOGIC_VECTOR (11 downto 0);
           ALU_F : in  STD_LOGIC_VECTOR (7 downto 0);
			  INT_OFFSET : in  STD_LOGIC_VECTOR (2 downto 0);
           CLK : in  STD_LOGIC;
           RD_OUT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           RD_OUT2 : out  STD_LOGIC_VECTOR (15 downto 0);
           MEM_DB : out  STD_LOGIC_VECTOR (15 downto 0);
           RD_F : out  STD_LOGIC_VECTOR (7 downto 0);
           PC_OUT : out  STD_LOGIC_VECTOR (11 downto 0);
           SP_OUT : out  STD_LOGIC_VECTOR (11 downto 0));
	end component REG_FILE_ALL;
	component BARREL_SHIFTER_16bit is
		Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           Y : out  STD_LOGIC_VECTOR (15 downto 0);
           SH : in  STD_LOGIC_VECTOR (6 downto 0));
	end component BARREL_SHIFTER_16bit;
	component ALU_16bit IS
		Port ( OP :  IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
         A      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         B      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         C_in   :  IN   STD_LOGIC;
         RESULT :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
         FLAGS  :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0));
	end component ALU_16bit;
	
	signal m_db, rf_db, instr, rf_wr_d, ab_in, a_bus, b_bus, alu_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal imm_sig, pc_out, sp_out : STD_LOGIC_VECTOR(11 DOWNTO 0);
	signal alu_flags : STD_LOGIC_VECTOR(3 DOWNTO 0);
begin
	IR: Reg_16bit port map (D_in => m_db, Q_out => instr, LOAD => IR_LOAD, CLK => CLK);
	REG_FILE: REG_FILE_ALL port map (RD_N1 => instr(9 downto 7), RD_N2 => instr(12 downto 10), LD_CTRL => RF_LD_CTRL,
											RD_CTRL => RF_RD_CTRL, WR_D => rf_wr_d, D_IN => RF_INPUT, IMMEDIATE => imm_sig,
											ALU_F(7 downto 4) => F_UPPER, ALU_F(3 downto 0) => alu_flags,
											INT_OFFSET => RF_INT_OFFSET, CLK => CLK, RD_OUT1 => ab_in, RD_OUT2 => b_bus, 
											MEM_DB => rf_db, RD_F => F_2CTRL, PC_OUT => pc_out, SP_OUT => sp_out);
	BARREL_SH: BARREL_SHIFTER_16bit port map (A => ab_in, Y => a_bus, SH => SH_CTRL);
	ALU: ALU_16bit port map (OP => ALU_OP, A => a_bus, B => b_bus, C_in => ALU_C_IN, RESULT => alu_res,
										FLAGS => alu_flags);
	process(SEL_CTRL, instr(11 downto 0), m_db, alu_res, sp_out, pc_out, rf_db, MEM_DB) 
	begin
		case SEL_CTRL(1 downto 0) is
			when "10" =>		--ld/st imm
				imm_sig <= (6 downto 0 => '0') & instr(4 downto 0);
			when "11" =>		--jmp imm
				imm_sig <= instr(11 downto 0);
			when others =>		--ldi and branch imm
				imm_sig <= (3 downto 0 => '0') & instr(7 downto 0);
		end case;
		case SEL_CTRL(2) is
			when '1' =>		--mem_db
				rf_wr_d <= m_db;
			when others =>	--alu
				rf_wr_d <= alu_res;
		end case;
		case SEL_CTRL(4 downto 3) is	--ab select
			when "01" =>	--stack pointer
				ADDR_BUS <= sp_out;
			when "10" =>	--alu
				ADDR_BUS <= alu_res(11 downto 0);
			when others =>	--program counter
				ADDR_BUS <= pc_out;
		end case;
		if SEL_CTRL(5) = '1' then
			MEM_DB <= rf_db;
		else
			rf_db <= "ZZZZZZZZZZZZZZZZ";
		end if;
	end process;
	
	m_db <= MEM_DB;
	INSTR_OPCODE <= instr(15 downto 13) & instr(1 downto 0);
end Behavioral;

