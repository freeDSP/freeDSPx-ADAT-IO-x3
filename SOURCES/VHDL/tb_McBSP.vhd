--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:42:10 12/30/2013
-- Design Name:   
-- Module Name:   Z:/ADAT DeEncoder/ADAT_De-Encoder/tb_McBSP.vhd
-- Project Name:  ADAT_De-Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: McBSP_Interface
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
use work.ADAT.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_McBSP IS
	generic( SCHNITTSTELLEN : natural := 3);
END tb_McBSP;
 
ARCHITECTURE behavior OF tb_McBSP IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT McBSP_Interface
	 generic ( SCHNITTSTELLEN : natural := 3
				  );
    PORT(
			-- McBSP
         CLKR : IN  bit;
         FSR : IN  bit;
         DR : IN  bit;
         CLKX : IN  bit;
         FSX : out  bit;
         DX : OUT  bit;
         --CLKS : IN  std_logic;
			
			-- ADAT-Puffer
			Daten_komplett_empfangen : OUT bit;
			--Daten_komplett_gesendet  : OUT bit;
			Neue_Daten_Zum_Senden : in bit;
			
			-- Daten
			Daten_Eingang : in ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
			Daten_Ausgang : out ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
			
			--Debug
			dbg_R_Schnittstellennummer : out natural;
			dbg_R_Kanalnummer : out natural;
			dbg_R_Bitnummer : out natural;
			dbg_X_Schnittstellennummer : out natural;
			dbg_X_Kanalnummer : out natural;
			dbg_X_Bitnummer : out natural
        );
    END COMPONENT;
    

   --Inputs
   signal CLKR : bit := '0';
   signal FSR : bit := '0';
   signal DR : bit := '0';
   signal CLKX : bit := '0';
   signal FSX : bit := '0';
   signal CLKS : bit := '0';
	signal Daten_Eingang : ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal Neue_Daten_Zum_Senden : bit;
 	--Outputs
   signal DX : bit;
	signal Daten_Ausgang : ADAT_Daten_Array(0 to SCHNITTSTELLEN-1);
	signal Daten_komplett_empfangen : bit := '0';
	--signal Daten_komplett_gesendet  : bit := '0';
	
	--Debug
	signal dbg_R_Schnittstellennummer : natural;
	signal dbg_R_Kanalnummer : natural;
	signal dbg_R_Bitnummer : natural;
	signal dbg_X_Schnittstellennummer : natural;
	signal dbg_X_Kanalnummer : natural;
	signal dbg_X_Bitnummer : natural;

   -- Clock period definitions
   constant CLKR_period : time := 10 ns;
   constant CLKX_period : time := 10 ns;
   constant CLKS_period : time := 10 ns;
	
	constant Daten : bit_vector := "101100111000111100001111";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: McBSP_Interface PORT MAP (
          CLKR => CLKR,
          FSR => FSR,
          DR => DR,
			 dbg_R_Schnittstellennummer => dbg_R_Schnittstellennummer,
			 dbg_R_Kanalnummer => dbg_R_Kanalnummer,
			 dbg_R_Bitnummer => dbg_R_Bitnummer,
			 Daten_komplett_empfangen => Daten_komplett_empfangen,
          CLKX => CLKX,
          FSX => FSX,
          DX => DX,
			 dbg_X_Schnittstellennummer => dbg_X_Schnittstellennummer,
			 dbg_X_Kanalnummer => dbg_X_Kanalnummer,
			 dbg_X_Bitnummer => dbg_X_Bitnummer,
			 Neue_Daten_Zum_Senden => Neue_Daten_Zum_Senden,
			 --Daten_komplett_gesendet => Daten_komplett_gesendet,
          --CLKS => CLKS,
			 Daten_Ausgang => Daten_Ausgang,
			 Daten_Eingang => Daten_Eingang
        );

   -- Clock process definitions
   CLKR_process :process
   begin
		CLKR <= '1';
		wait for CLKR_period/2;
		CLKR <= '0';
		wait for CLKR_period/2;
   end process;
 
   CLKX_process :process
   begin
		CLKX <= '1';
		wait for CLKX_period/2;
		CLKX <= '0';
		wait for CLKX_period/2;
		--wait;
   end process;
 
   --CLKS_process :process
   --begin
	--	CLKS <= '0';
		--wait for CLKS_period/2;
		--CLKS <= '1';
		--wait for CLKS_period/2;
	--	wait;
   --end process;
 

--   -- Stimulus process
--   stim_proc_Lesen: process
--   begin		
--      -- hold reset state for 100 ns.
--      wait for 100 ns;	
--
--      wait for CLKR_period*10;
--		
--		-- insert stimulus here 
--		for Frame in 0 to 50 loop
--			wait for CLKR_period*0.1;
--			FSR <= '1';
--			wait for CLKR_period;
--			FSR <= '0';
--			
--			for Schnittstelle in 0 to SCHNITTSTELLEN-1 loop
--				for Kanal in 0 to 7 loop
--					for Bit in 0 to 23 loop
--						DR <= Daten(Bit);
--						if (Schnittstelle = 0 and Kanal =0 and Bit = 0) then 
--							wait for CLKR_period*0.9;
--						else
--							wait for CLKR_Period;
--						end if;
--					end loop;
--				end loop;
--				DR <= '1';
--				wait for CLKR_period;
--				DR <= '0';
--				wait for CLKR_period;
--				DR <= '0';
--				wait for CLKR_period;
--				DR <= '1';
--				wait for CLKR_period;
--			end loop;
--			wait for CLKR_period*42;
--		end loop;
--		--Warten, bis nächster ADAT-Frame kommt:
--      wait;
--   end process;
	DR <= DX;
	--CLKR <= CLKX;
	FSR <= FSX;

-- Stimulus process
   stim_proc_Schreiben: process
		variable Schnittstelle_vec : bit_vector(1 to 3):= "100";
		variable Kanal_vec : bit_vector(0 to 7):="10000000";
		
   begin
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLKX_period*15.2;
		
		-- insert stimulus here 
		for Frame in 0 to 50 loop
			
			--Daten Vorbereiten--
			for Schnittstelle in 0 to SCHNITTSTELLEN-1 loop
				for Kanal in 0 to 7 loop
					Daten_Eingang(Schnittstelle).Kanaele(Kanal)<= '1' & Schnittstelle_vec & Kanal_vec & '1' & Schnittstelle_vec & Kanal_vec;
					Kanal_vec:=Kanal_vec ror 1;
				end loop;
				Schnittstelle_vec := Schnittstelle_vec ror 1;
				Daten_Eingang(Schnittstelle).Userbits <= "1000" ror Frame;
			end loop;
			---------------------
--			FSX <= '1';
--			wait for CLKX_period;
--			FSX <= '0';
			Neue_Daten_Zum_Senden <= not Neue_Daten_Zum_Senden;
			wait for CLKX_period;
			for Schnittstelle in 0 to SCHNITTSTELLEN-1 loop
				for Kanal in 0 to 7 loop
					for Bit in 0 to 23 loop
						--DR <= Daten(Bit);
						wait for CLKX_period;
					end loop;
				end loop;
				--DR <= '1';
				wait for CLKX_period;
				--DR <= '0';
				wait for CLKX_period;
				--DR <= '0';
				wait for CLKX_period;
				--DR <= '1';
				wait for CLKX_period;
	
			end loop;
			--Warten, bis nächster ADAT-Frame kommt:
			wait for CLKX_period*42;
		end loop;
      wait;
   end process;

END;
