----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:10:56 11/02/2017 
-- Design Name: 
-- Module Name:    COUNTER_UN_12bit - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity COUNTER_UN_12bit is
    Port ( D_in : in  STD_LOGIC_VECTOR (11 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (11 downto 0);
           SEL : in  STD_LOGIC_VECTOR (1 downto 0);
           RESET : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end COUNTER_UN_12bit;

architecture Behavioral of COUNTER_UN_12bit is
begin
	process (CLK, RESET, SEL)
		variable temp : unsigned(11 downto 0);
	begin
		if RESET = '1' then
			temp := (others => '0');
		elsif rising_edge(CLK) then
			case (SEL) is
				when "00" =>
					temp := temp + 1;
				when "01" =>
					temp := unsigned(D_in);
				when "10" =>
					temp := temp;
				when others =>
					temp := temp - 1;
			end case;
		end if;
		Q_out <= std_logic_vector(temp);
	end process;
end Behavioral;

