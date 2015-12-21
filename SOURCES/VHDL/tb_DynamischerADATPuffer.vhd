--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:51:41 11/12/2013
-- Design Name:   
-- Module Name:   Z:/ADAT DeEncoder/ADAT_De-Encoder/tb_DynamischerADATPuffer.vhd
-- Project Name:  ADAT_De-Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DynamischerADATPuffer
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
use IEEE.numeric_std.all;
use work.ADAT.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_DynamischerADATPuffer IS
END tb_DynamischerADATPuffer;
 
ARCHITECTURE behavior OF tb_DynamischerADATPuffer IS 
		constant KANAELE : natural := 3;
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DynamischerADATPuffer
	 generic(PUFFERLAENGE : integer := 4; --Wie viele Elemente soll der Puffer maximal aufnehmen können?
				PUFFERBREITE : integer := 3 --Wie viele ADAT-Schnittstellen?
				); 
				
    PORT(
			Reset : in bit;
		  clk : in std_logic;
		  -- Eingang --
		  Eingang_NeueDatenAngekommen	: in bit; --Wechselt, wenn neue Daten am Eingang liegen
		  Eingang : in ADAT_Daten_Array(0 to KANAELE-1);
		  -- Ausgang --
		  PufferVoll : out bit := '0';
		  PufferLeer : out bit := '1';
		  PufferUeberlauf : out bit := '0'; 
		  PufferUnterlauf : out bit := '0'; 
		  
		  Ausgang_NaechsterDatensatz : in bit; --Wechselt, wenn der nächste Frame an den Ausgang gelegt werden soll
		  Ausgang : out ADAT_Daten_Array(0 to KANAELE-1)
        );
    END COMPONENT;
    

   --Inputs
	signal Reset : bit := '0';
   signal Eingang_NeueDatenAngekommen : bit := '0';
   signal Eingang : ADAT_Daten_Array(0 to KANAELE-1);
   signal Ausgang_NaechsterDatensatz : bit := '0';
	signal tb_clk : std_logic := '1';

 	--Outputs
   signal PufferVoll : bit;
   signal PufferLeer : bit;
   signal PufferUeberlauf : bit;
   signal PufferUnterlauf : bit;
   signal Ausgang : ADAT_Daten_Array(0 to KANAELE-1);
	
	--Debug
	signal tb_Info : string(1 to 30);
BEGIN
	tb_clk  <= not tb_clk after 10 ns; --5ns -> 100MHz  
	-- Instantiate the Unit Under Test (UUT)
   uut: DynamischerADATPuffer PORT MAP (
			 clk => tb_clk,
			 Reset => Reset,
          Eingang_NeueDatenAngekommen => Eingang_NeueDatenAngekommen,
          Eingang => Eingang,
          PufferVoll => PufferVoll,
          PufferLeer => PufferLeer,
          PufferUeberlauf => PufferUeberlauf,
          PufferUnterlauf => PufferUnterlauf,
          Ausgang_NaechsterDatensatz => Ausgang_NaechsterDatensatz,
          Ausgang => Ausgang
        );

   -- Stimulus process
   stim_proc: process
		variable Daten : ADAT_Daten;
   begin		
      -- # Schneller lesen als schreiben # --
		tb_Info <= "Schneller lesen als schreiben ";
		for j in 0 to 10 loop
			for i in 0 to 3 loop
				wait for 100 ns;	
				Daten.UserBits(i) := not Daten.UserBits(i);
				for kanal in 0 to KANAELE-1 loop
					Eingang(kanal) <= Daten;
				end loop;
				Eingang_NeueDatenAngekommen <= not Eingang_NeueDatenAngekommen;
				Ausgang_NaechsterDatensatz <= not Ausgang_NaechsterDatensatz, Ausgang_NaechsterDatensatz after 50 ns;
			end loop;
		end loop;
		
		tb_Info <= "Puffer Reset                  ";
		wait for 500 ns;
		Reset <= '1';
		wait for 500 ns;
		Reset <= '0';
		
		-- # Schneller schreiben als lesen # --
		tb_Info <= "Schneller schreiben als lesen ";
		for j in 0 to 10 loop
			for i in 0 to 3 loop
				wait for 100 ns;	
				Daten.UserBits(i) := not Daten.UserBits(i);
				for kanal in 0 to KANAELE-1 loop
					Eingang(kanal) <= Daten;
				end loop;
				Eingang_NeueDatenAngekommen <= not Eingang_NeueDatenAngekommen;
				
				if (i mod 2 = 0) then
					Ausgang_NaechsterDatensatz <= not Ausgang_NaechsterDatensatz;
				end if;
			end loop;
		end loop;
		
		tb_Info <= "Puffer Reset                  ";
		wait for 500 ns;
		Reset <= '1';
		wait for 500 ns;
		Reset <= '0';
		
		-- # Synchron lesen und schreiben # --
		tb_Info <= "Synchron lesen und schreiben  ";
		
		for j in 0 to 10 loop
			for i in 0 to 3 loop
				wait for 100 ns;	
				Daten.UserBits(i) := not Daten.UserBits(i);
				for kanal in 0 to KANAELE-1 loop
					Eingang(kanal) <= Daten;
				end loop;
				Eingang_NeueDatenAngekommen <= not Eingang_NeueDatenAngekommen;
				
				Ausgang_NaechsterDatensatz <= not Ausgang_NaechsterDatensatz;
			end loop;
		end loop;
		tb_Info <= " - ENDE - ENDE - ENDE - ENDE -";
		wait; --ende
   end process;

END;
