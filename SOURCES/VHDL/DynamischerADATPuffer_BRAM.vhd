----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:53:51 11/11/2013 
-- Design Name: 
-- Module Name:    DynamischerAudioPuffer - Behavioral 
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
use work.ADAT.all;


entity DynamischerADATPuffer_BRAM is
	generic (PUFFERLAENGE : integer := 2; --Wie viele Elemente soll der Puffer maximal aufnehmen können?
				PUFFERBREITE : integer := 3  --Wie viele ADAT-Schnittstellen?
				); 
	
	Port ( 
		  Reset : in bit;
		  clk : in std_logic;
		  -- Eingang --
		  Eingang_NeueDatenAngekommen	: in bit; --Wechselt, wenn neue Daten am Eingang liegen
		  Eingang : in ADAT_Daten_Array(0 to PUFFERBREITE-1);
		  
		  -- Ausgang --
		  PufferVoll : out bit := '0';
		  PufferLeer : out bit := '1';
		  PufferUeberlauf : out bit := '0'; 
		  PufferUnterlauf : out bit := '0'; 
		  
		  Ausgang_NaechsterDatensatz : in bit; --Wechselt, wenn der nächste Frame an den Ausgang gelegt werden soll
		  
		  Ausgang : out ADAT_Daten_Array(0 to PUFFERBREITE-1)
		  );
			  
end DynamischerADATPuffer_BRAM;

architecture Behavioral of DynamischerADATPuffer_BRAM is
	COMPONENT ADAT_BLOCKRAM
		generic( ADAT_SCHNITTSTELLEN : natural;
					PUFFER_LAENGE : natural
				  );
		port(clk  : in std_logic;
			  we   : in std_logic;
			  en 	 : in  std_logic;
			  addr : in natural;
			  di	 : in bit_vector(ADAT_DATENMENGE*PUFFERBREITE-1 downto 0);
			  do	 : out bit_vector(ADAT_DATENMENGE*PUFFERBREITE-1 downto 0)
			  );
	END COMPONENT;
	
	signal BR_clk  : std_logic;
   signal BR_we   : std_logic;
   signal BR_addr : natural;
   --signal BR_di	: bit_vector(ADAT_DATENMENGE*PUFFERBREITE-1 downto 0);
   signal BR_do	: bit_vector(ADAT_DATENMENGE*PUFFERBREITE-1 downto 0);
begin
	instADAT_BLOCKRAM : ADAT_BLOCKRAM
		generic map(
			ADAT_SCHNITTSTELLEN => PUFFERBREITE,
			PUFFER_LAENGE => PUFFERLAENGE
			)
		PORT MAP (
			clk => BR_clk,
			we => BR_we,
			en => '1',
			addr => BR_addr,
			di => AdatDatenArray_TO_Bitvector(Eingang),
			do => BR_do
		);
		
	RAM_Verdrahten: for ADAT_Kanal in 0 to PUFFERBREITE-1 generate
		--Signale:
	begin
--		BR_di(ADAT_DATENMENGE*(ADAT_Kanal+1)-1 downto ADAT_DATENMENGE*ADAT_Kanal) <= (Eingang(ADAT_Kanal).UserBits
--																											 & Eingang(ADAT_Kanal).Kanaele(7) & Eingang(ADAT_Kanal).Kanaele(6)
--																											 & Eingang(ADAT_Kanal).Kanaele(5) & Eingang(ADAT_Kanal).Kanaele(4)
--																											 & Eingang(ADAT_Kanal).Kanaele(3) & Eingang(ADAT_Kanal).Kanaele(2)
--																											 & Eingang(ADAT_Kanal).Kanaele(1) & Eingang(ADAT_Kanal).Kanaele(0));
		--[MINADDR]  CH0_MSB ... CH0_LSB | CH1_MSB ... CH1_LSB | ... | USER_MSB ... USER LSB  [MAXADDR]
																											
		Ausgang(ADAT_Kanal).Kanaele(0) <= BR_do( ADAT_DATENMENGE*ADAT_Kanal +0*24 +23 downto ADAT_DATENMENGE*ADAT_Kanal +0*24 );
		Ausgang(ADAT_Kanal).Kanaele(1) <= BR_do( ADAT_DATENMENGE*ADAT_Kanal +1*24 +23 downto ADAT_DATENMENGE*ADAT_Kanal +1*24 );
		Ausgang(ADAT_Kanal).Kanaele(2) <= BR_do( ADAT_DATENMENGE*ADAT_Kanal +2*24 +23 downto ADAT_DATENMENGE*ADAT_Kanal +2*24 );
		Ausgang(ADAT_Kanal).Kanaele(3) <= BR_do( ADAT_DATENMENGE*ADAT_Kanal +3*24 +23 downto ADAT_DATENMENGE*ADAT_Kanal +3*24 );
		Ausgang(ADAT_Kanal).Kanaele(4) <= BR_do( ADAT_DATENMENGE*ADAT_Kanal +4*24 +23 downto ADAT_DATENMENGE*ADAT_Kanal +4*24 );
		Ausgang(ADAT_Kanal).Kanaele(5) <= BR_do( ADAT_DATENMENGE*ADAT_Kanal +5*24 +23 downto ADAT_DATENMENGE*ADAT_Kanal +5*24 );
		Ausgang(ADAT_Kanal).Kanaele(6) <= BR_do( ADAT_DATENMENGE*ADAT_Kanal +6*24 +23 downto ADAT_DATENMENGE*ADAT_Kanal +6*24 );
		Ausgang(ADAT_Kanal).Kanaele(7) <= BR_do( ADAT_DATENMENGE*ADAT_Kanal +7*24 +23 downto ADAT_DATENMENGE*ADAT_Kanal +7*24 );
		
		Ausgang(ADAT_Kanal).UserBits   <= BR_do( ADAT_DATENMENGE*ADAT_Kanal +8*24 +3  downto ADAT_DATENMENGE*ADAT_Kanal +8*24 );
	end generate;
	
	IO: process (clk)
		variable Anfang : natural range 0 to PUFFERLAENGE-1 := 0; --Erstes gültiges Pufferelement
		variable Laenge : natural range 0 to PUFFERLAENGE := 0; --Anzahl der gültigen Elemente im Puffer
		
		variable Eingang_NeueDatenAngekommen_alt : bit := '0';
		variable Ausgang_NaechsterDatensatz_alt : bit := '0';
		
		variable RamAddresse : integer := 0;
		variable VerzoegerterRamTakt_noetig : boolean := false;
	begin
		if rising_edge(clk) then
			if Reset = '1' then --Synchroner Reset
				Anfang := 0;
				Laenge := 0;
				PufferUeberlauf <= '0';
				PufferUnterlauf <= '0';
				PufferVoll <= '0';
				PufferLeer <= '1';
			else
				-- Ringpuffer --
				if VerzoegerterRamTakt_noetig = true then
					BR_clk <= '1';
					VerzoegerterRamTakt_noetig := false;
				else
					-- Neue Daten sind angekommen
					if Eingang_NeueDatenAngekommen /= Eingang_NeueDatenAngekommen_alt then
						if Laenge = PUFFERLAENGE then
							PufferUeberlauf <= '1';
						else
							PufferUeberlauf <= '0';
							-- Daten einlesen
							--#Puffer( (Anfang + Laenge) mod PUFFERLAENGE ) := Eingang;
							BR_addr <= (Anfang + Laenge) mod PUFFERLAENGE;
							BR_we <= '1';
							BR_clk <= '0';
							VerzoegerterRamTakt_noetig := true;
							
							Laenge := Laenge + 1;
							PufferLeer <= '0';
							-- Flag: Puffer voll ?
							if Laenge = PUFFERLAENGE then
								PufferVoll <= '1';
							else
								PufferVoll <= '0';
							end if;
						end if;
						Eingang_NeueDatenAngekommen_alt := Eingang_NeueDatenAngekommen; --letzen Zustand merken, steht hier, damit der Puffer Zeit hat um sich zu leeren, falls ein Überlauf aufgetreten ist
					-- Daten Ausgeben:
					--end if;
					elsif Ausgang_NaechsterDatensatz /= Ausgang_NaechsterDatensatz_alt then
						if Laenge = 0 then
							PufferUnterlauf <= '1';
						else			
							PufferUnterlauf <= '0';
							--#Ausgang <= Puffer(Anfang);
							BR_addr <= Anfang;
							BR_we <= '0'; --lesen
							BR_clk <= '0';
							VerzoegerterRamTakt_noetig := true;
							
							Anfang := (Anfang + 1) mod PUFFERLAENGE;
							Laenge := Laenge - 1;
							PufferVoll <= '0';
							-- Flag: Puffer leer ?
							if Laenge = 0 then
								PufferLeer <= '1';
							else
								PufferLeer <= '0';
							end if;
						end if;
						Ausgang_NaechsterDatensatz_alt := Ausgang_NaechsterDatensatz; --letzen Zustand merken, steht hier, damit der Puffer Zeit hat um sich aufzufüllen, falls ein Unterlauf aufgetreten ist
					--else
						--BR_clk <= '0';
					end if;
				end if;--VerzoegerterRamTakt_noetig = true then
			end if;--if Reset = '1' then 
		end if;--if rising_edge(clk) then
	end process;


end Behavioral;



