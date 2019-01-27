--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:30:46 12/10/2018
-- Design Name:   
-- Module Name:   C:/Users/Emertat/Desktop/session7/divisor/test.vhd
-- Project Name:  divisor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: division
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT division
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         clk : IN  std_logic;
         Start : IN  std_logic;
         baghimande : OUT  std_logic_vector(15 downto 0);
         outQ : OUT  std_logic_vector(15 downto 0);
         Done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(15 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal Start : std_logic := '0';

 	--Outputs
   signal baghimande : std_logic_vector(15 downto 0);
   signal outQ : std_logic_vector(15 downto 0);
   signal Done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: division PORT MAP (
          A => A,
          B => B,
          clk => clk,
          Start => Start,
          baghimande => baghimande,
          outQ => outQ,
          Done => Done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   --A <= "11111111111111111111111111110011" ;
	 A <= "00000000000000000000000000001101" ;
	   --   B <="0000000000000110";
		   B <="1111111111111010";
      Start <= '1', '0' after 150 ns;

END;
