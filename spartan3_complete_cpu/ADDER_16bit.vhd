----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:27:20 10/31/2017 
-- Design Name: 
-- Module Name:    ADDER_16bit - Behavioral 
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ADDER_16bit IS
    PORT
        (
         x_in      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         carry_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
         carry_out :  OUT  STD_LOGIC
        );
END ADDER_16bit;

ARCHITECTURE behavioral OF ADDER_16bit IS

SIGNAL    h_sum              :    STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL    carry_generate     :    STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL    carry_propagate    :    STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL    carry_in_internal  :    STD_LOGIC_VECTOR(15 DOWNTO 1);

BEGIN
    h_sum <= x_in XOR y_in;
    carry_generate <= x_in AND y_in;
    carry_propagate <= x_in OR y_in;
    PROCESS (carry_generate,carry_propagate,carry_in_internal,carry_in)
    BEGIN
    carry_in_internal(1) <= carry_generate(0) OR (carry_propagate(0) AND carry_in);
        inst: FOR i IN 1 TO 14 LOOP
              carry_in_internal(i+1) <= carry_generate(i) OR (carry_propagate(i) AND carry_in_internal(i));
              END LOOP;
    carry_out <= carry_generate(15) OR (carry_propagate(15) AND carry_in_internal(15));
    END PROCESS;

    sum(0) <= h_sum(0) XOR carry_in;
    sum(15 DOWNTO 1) <= h_sum(15 DOWNTO 1) XOR carry_in_internal(15 DOWNTO 1);
END behavioral;

