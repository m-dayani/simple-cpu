----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:02:45 10/31/2017 
-- Design Name: 
-- Module Name:    ALU_16bit - Behavioral 
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

ENTITY ALU_16bit IS
    PORT
        (
		   OP     :  IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
         A      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         B      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         C_in   :  IN   STD_LOGIC;
         RESULT :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
         FLAGS  :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
END ALU_16bit;

architecture Behavioral of ALU_16bit is
	component MUX_4x1_16bit is
    Port ( D0     : in  STD_LOGIC_VECTOR (15 downto 0);
           D1     : in  STD_LOGIC_VECTOR (15 downto 0);
           D2     : in  STD_LOGIC_VECTOR (15 downto 0);
           D3     : in  STD_LOGIC_VECTOR (15 downto 0);
           SEL    : in  STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0));
	end component MUX_4x1_16bit;
	component ADDER_16bit is
    PORT
        (
         x_in      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         carry_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
         carry_out :  OUT  STD_LOGIC
        );
	end component ADDER_16bit;
	
	signal and_res, or_res, add_res, a_res, f_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
	a_mux: MUX_4x1_16bit port map (D0 => A, D1 => not A, D2 => (15 downto 0 => '0'), D3 => (15 downto 0 => '1'),
												SEL => OP(3 downto 2), OUTPUT => a_res);
	
	and_res <= a_res and B;
	or_res <= a_res or B;
	
	add_op: ADDER_16bit port map (x_in => a_res, y_in => B, carry_in => C_in, sum => add_res, 
											carry_out => FLAGS(0));
	final_res: MUX_4x1_16bit port map (D0 => a_res, D1 => and_res, D2 => or_res, D3 => add_res,
													SEL => OP(1 downto 0), OUTPUT => f_res);
	process(f_res)	--zero flag
	begin
		if f_res = "0000000000000000" then
			FLAGS(1) <= '1';
		else
			FLAGS(1) <= '0';
		end if;	
	end process;
	FLAGS(2) <= f_res(15);	--negate flag
	FLAGS(3) <= '1' WHEN (OP(1 downto 0)="11" AND a_res(15)=B(15) AND f_res(15)/=a_res(15)) ELSE '0';
	
	RESULT <= f_res;
end Behavioral;

