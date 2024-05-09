----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:34:41 10/31/2017 
-- Design Name: 
-- Module Name:    MUX_4x1_16bit - Behavioral 
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

entity MUX_4x1_16bit is
    Port ( D0 : in  STD_LOGIC_VECTOR (15 downto 0);
           D1 : in  STD_LOGIC_VECTOR (15 downto 0);
           D2 : in  STD_LOGIC_VECTOR (15 downto 0);
           D3 : in  STD_LOGIC_VECTOR (15 downto 0);
           SEL : in  STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0));
end MUX_4x1_16bit;

architecture Behavioral of MUX_4x1_16bit is
begin
	process(SEL, D0, D1, D2, D3)
		variable temp: std_logic_vector(15 downto 0);
	begin
		case SEL is
			when "00" =>
				temp := D0;
			when "01" =>
				temp := D1;
			when "10" =>
				temp := D2;
			when "11" =>
				temp := D3;
			when others =>
				temp := D0;
		end case;
		OUTPUT <= temp;
	end process;
end Behavioral;

