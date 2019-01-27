----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:36:14 11/27/2018 
-- Design Name: 
-- Module Name:    division - Behavioral 
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
--use IEEE.STD_LOGIC_arith.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity division is
Port( 
	   A : in  STD_LOGIC_VECTOR (31 downto 0);
      B : in  STD_LOGIC_VECTOR (15 downto 0);
      clk : in  STD_LOGIC;
      Start : in  STD_LOGIC;
      baghimande : out  STD_LOGIC_VECTOR (15 downto 0);
      outQ : out  STD_LOGIC_VECTOR (15 downto 0);
      Done : out  STD_LOGIC
);
end division;

architecture Behavioral of division is
type state is (S0, S1, S2, S3, S4);
signal currentState, nextState: state;
signal signalDone: STD_LOGIC;
Signal SC: STD_LOGIC_VECTOR (4 downto 0);

Signal tempA : STD_LOGIC_VECTOR (31 downto 0);
Signal tempB : STD_LOGIC_VECTOR (15 downto 0);
Signal tempAA : STD_LOGIC_VECTOR (31 downto 0);
Signal tempBB : STD_LOGIC_VECTOR (15 downto 0);
Signal tempAAA : STD_LOGIC_VECTOR (31 downto 0);
Signal sum : STD_LOGIC_VECTOR (15 downto 0);


signal cnt: STD_LOGIC;
signal loadSum: STD_LOGIC;
signal ShiftLeft0: STD_LOGIC;
signal ShiftLeft1: STD_LOGIC;

---------------------------------------------------------------------
---------------------------------------------------------------------


begin
beginstart: process (clk, start)
begin
		if clk'event and clk = '1' then
			if start = '1' then
				if B(15) = '0' then
					tempB <= B;
				else
					tempB <= not B + 1;
				end if;
				
				tempBB <= B;
			end if;
		end if;
end process;

-----------------------------------------------------------

Counter: process(clk, start)
begin
		if clk'event and clk = '1' then
			if start = '1' then
				SC <= (others => '0');
			elsif cnt = '1' then
				SC <= SC+1;
         end if;
		end if;
end process;

-----------------------------------------------------------

checker: process(tempA, tempB)
begin
         sum <= tempA(31 downto 16) + (not(tempB) + 1);
end process;

-----------------------------------------------------------

Result: process(tempA)
begin  
		if (tempAA(31) or tempBB(15)) = '0' then
			outQ  <= tempA(15 downto 0);     
			baghimande <= '0' & tempA(31 downto 17);
			
		elsif (tempAA(31) and tempBB(15)) = '1' then
			outQ  <= tempA(15 downto 0);     
			baghimande <= not('0' & tempA(31 downto 17)) + 1;
		
		elsif '0' & tempA(31 downto 17) = "0000000000000000" then
			outQ  <= not tempA(15 downto 0) + 1;
			baghimande <= "0000000000000000";
			
		elsif ((not tempAA(31)) and tempBB(15)) = '1' then
			outQ  <= not (tempA(15 downto 0) + 1) + 1;     
			baghimande <= ('0' & tempA(31 downto 17)) + tempBB;
			
		else 
			outQ  <= not (tempA(15 downto 0) + 1) + 1;     
			baghimande <= not ('0' & tempA(31 downto 17)) + 1 + tempB;
		end if;
end process;

-----------------------------------------------------------

tempAreg: process (clk, start, A, sum, ShiftLeft0, ShiftLeft1, loadSum)
begin
	if clk'event and clk = '1' then
      if start = '1' then
			if A(31) = '0' then
				tempA <= A(30 downto 0) & '0';
			else
				tempAAA <= not A + 1;
				tempA <= tempAAA(30 downto 0) & '0';
			end if;
			
			tempAA <= A;
      elsif loadSum = '1' then
         tempA(31 downto 16) <= sum;
      elsif ShiftLeft0 = '1' then
         tempA <= tempA(30 downto 0) & '0';
      elsif ShiftLeft1 = '1' then
         tempA <= tempA(30 downto 0) & '1';
		end if;
	end if;   
end process;

----------------------------------------------------------

output: process(currentState, start, sum, signalDone)
begin
   cnt <= '0';
   loadSum <= '0';
   ShiftLeft0 <= '0';
   ShiftLeft1 <= '0';
	
	case currentState is
	
		when S0 =>
				if start = '1' then
					nextState <= S0;
				elsif sum(15) = '0' then
					nextState <= S1;         
				else
					nextState <= S2;
				end if;
                 
		when S1 =>
            loadSum <= '1';
            nextState <= S3;
                 
		when S2 =>
            ShiftLeft0 <= '1';
            cnt <= '1';
            nextState <= S4;
               
		when S3 =>
            ShiftLeft1 <= '1';
            cnt <= '1';
            nextState <= S4;
               
		when S4 =>
				if signalDone = '1' then
					nextState <= S4;
            else 
					nextState <= S0;
            end if;
	end case;
end process;

-----------------------------------------------------------

states: process (clk, nextState, start)
begin
	if (clk'event and clk = '1') then
		if start = '1' then
			currentState <= S0;
		else
			currentState <= nextState;
		end if;
	end if;
end process;

-----------------------------------------------------------

counter_done: process(SC)
begin
   signalDone <= ( (SC(4)) and (not(SC(3)))  and (not(SC(2))) and (not(SC(1)))  and (not(SC(0))) );
end process;

-----------------------------------------------------------

process(signalDone)
begin
        done <= signalDone;
end process;


end Behavioral;

