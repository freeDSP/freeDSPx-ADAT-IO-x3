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



entity DynamischerADATPuffer is
	generic (PUFFERLAENGE : integer := 2; --Wie viele Elemente soll der Puffer maximal aufnehmen können?
				PUFFERBREITE : integer := 1 --Wie viele ADAT-Schnittstellen?
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
			  
end DynamischerADATPuffer;

architecture Behavioral of DynamischerADATPuffer is
	
begin
	IO: process (clk)
		type ADAT_Puffer_Array is array (0 to PUFFERLAENGE-1) of ADAT_Daten_Array(0 to PUFFERBREITE-1);
		variable Puffer : ADAT_Puffer_Array;  
		variable Anfang : integer range 0 to PUFFERLAENGE-1 := 0; --Erstes gültiges Pufferelement
		variable Laenge : integer range 0 to PUFFERLAENGE := 0; --Anzahl der gültigen Elemente im Puffer
		
		variable Eingang_NeueDatenAngekommen_alt : bit := '0';
		variable Ausgang_NaechsterDatensatz_alt : bit := '0';
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
				
				-- Neue Daten sind angekommen
				if Eingang_NeueDatenAngekommen /= Eingang_NeueDatenAngekommen_alt then
					if Laenge = PUFFERLAENGE then
						PufferUeberlauf <= '1';
					else
						PufferUeberlauf <= '0'; --TODO: zurücksetzen oder nicht?
						-- Daten einlesen
						Puffer( (Anfang + Laenge) mod PUFFERLAENGE ) := Eingang;
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
						PufferUnterlauf <= '0'; --TODO: zurücksetzen oder nicht?
						Ausgang <= Puffer(Anfang);
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
				end if;
				
			end if;--if Reset = '1' then 
		end if;--if rising_edge(clk) then
	end process;

end Behavioral;


