--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:59:56 06/24/2014
-- Design Name:   
-- Module Name:   D:/ADAT DeEncoder/ADAT_De-Encoder/tb_Delayline_BRAM.vhd
-- Project Name:  ADAT_De-Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Delayline_BRAM
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
USE IEEE.numeric_std.ALL;
 
 
ENTITY tb_Delayline_BRAM IS
END tb_Delayline_BRAM;
 
ARCHITECTURE behavior OF tb_Delayline_BRAM IS 
	constant Wortbreite     : natural := 3; 
	constant addrbreite : natural := 8;
	
	constant tb_signalverschiebung : natural range 0 to 255:= 0; 
	--constant delay      : natural := 3;
	
    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT Delayline_BRAM
	 Generic (
           Addrbreite  : natural := 8;  -- Speicherlänge = 2^Addrbreite
           Wortbreite  : natural := 8
           );
    PORT(
         clk    : IN  std_logic;
         input  : IN  bit_vector(Wortbreite-1 downto 0);
         delay  : IN  natural;
         output : buffer bit_vector(Wortbreite-1 downto 0);
			dbg_adrrd : out  natural;
			dbg_adrwr: out natural
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal input : bit_vector(Wortbreite-1 downto 0) := (others => '0');
   signal delay : natural;

 	--Outputs
   signal output : bit_vector(Wortbreite-1 downto 0);

	--Debug
	signal tb_dbg_adrrd :  natural;
	signal tb_dbg_adrwr:  natural;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Delayline_BRAM 
		Generic Map ( Addrbreite => Addrbreite,
						  Wortbreite => Wortbreite)
		PORT MAP (
          clk => clk,
          input => input,
          delay => delay,
          output => output,
			 dbg_adrrd => tb_dbg_adrrd,
			 dbg_adrwr => tb_dbg_adrwr
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
   stim_proc: process
		variable muster: bit_vector(0 to 255) := "1111110000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000000000";
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		for verz in 0 to 255 loop
			delay <= verz;
			for wiederholung in 0 to 50 loop
				for i in 0 to muster'length-1 loop
					for ch in 0 to Wortbreite-1 loop
						input(ch) <= muster((i+(ch*tb_signalverschiebung)) mod (muster'length-1));
					end loop;
					wait for clk_period;	
				end loop;
			end loop;
			for ch in 0 to Wortbreite-1 loop
				input(ch) <= '0';
			end loop;
			wait for 300*clk_period; --Abstand zwischen den verschiedenen Verzögerungen
		end loop;
      wait;
   end process;

END;
