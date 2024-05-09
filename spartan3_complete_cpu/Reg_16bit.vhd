----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:07:42 11/02/2017 
-- Design Name: 
-- Module Name:    Reg_16bit - Behavioral 
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

entity Reg_16bit is
    Port ( D_in : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (15 downto 0);
           LOAD : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end Reg_16bit;

architecture Behavioral of Reg_16bit is
	signal temp : STD_LOGIC_VECTOR (15 downto 0);
begin
	process(CLK, LOAD, temp)
	begin
		if rising_edge(CLK) and LOAD = '1' then
			temp <= D_in;
		else
			temp <= temp;
		end if;
	end process;
	Q_out <= temp;
end Behavioral;

