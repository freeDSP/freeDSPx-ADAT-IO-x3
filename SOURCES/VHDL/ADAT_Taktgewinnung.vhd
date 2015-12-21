
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ADAT.all;

Library UNISIM; --BUFGMUX
use UNISIM.vcomponents.all; --BUFGMUX

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADAT_Taktgewinnung is
	generic (AdatSchnittstellen : integer := 3);--Anzahl der Adat-Schnittstellen, von denen Daten entgegen genommen werden sollen
	Port  ( clk 			  : in std_logic;
			  -- Daten-Eingang
			  In_ADAT 		  : in bit;
			  
			  -- Takt-Ausgang
			  Out_ADAT_Clock : out std_logic := '0';
			  Frame_Sync     : out std_logic := '0'
			  );
			  
	attribute clock_signal : string;
	attribute clock_signal of clk : signal is "yes";
	attribute max_fanout : string;
	attribute max_fanout of clk: signal is "2";
				
end ADAT_Taktgewinnung;

architecture Verhalten of ADAT_Taktgewinnung is
	--signal Intern_ADAT_Clock : bit;
	signal Takt : std_logic;
begin
	BUFG_inst : BUFG
		port map (
			O => Takt, -- Clock buffer output
			I => clk -- Clock buffer input
		);

	Sync_Erkennung: process (Takt)
	   --Verzögerte Signale
		variable ADAT_In_Letzter_Wert: bit;
		variable Sync_Letzer_Wert: std_logic;
		variable ADAT_Takt_Letzer_Wert: std_logic;
		
		--Sync
		constant AenderungenBisUebernahme: natural := 200;

		variable Zeit_ohne_Aenderung: natural range 0 to 1023 := 0;
		variable Zeit_ohne_Aenderung_max: natural range 0 to 1023 := 0;
		variable SignalAenderungen: natural range 0 to 300 := 0;
		variable Sync_Laenge: natural range 0 to 255 := 0;
		variable Sync_ErkennungsLaenge:natural range 0 to 127 := 0;
		variable Sync: std_logic := '0';
		
		--Bit-Takt
		variable Sync_FrameLaengeZaehler: natural range 0 to 1023:=1;
		variable Sync_FrameLaenge: natural range 1 to 1024:=1;
		variable Bitlaengen_Zaehler: natural range 0 to 4:=1;
		variable Sync_BitLaenge: natural range 0 to 4:=1; --Sync_FrameLaenge/256 --TODO: eigentlich nicht ab 0
		variable ADAT_Takt: std_logic;
	begin
		if rising_edge(Takt) then --steigende Flanke auf CLK (Wegen Synchronisierung im FPGA)
			------------------------
			-- Erst Sync erkennen --
			------------------------
			if (In_ADAT = ADAT_In_Letzter_Wert) then -- Dauer ohne Änderungen am Eingang
				Zeit_ohne_Aenderung := Zeit_ohne_Aenderung + 1; -- ...im ADAT-Signal messen
				if (Zeit_ohne_Aenderung = Sync_Erkennungslaenge) then -- Wenn die Mindestdauer zur Erkennung des Sync-Signals erreicht ist,
					Sync := '1';								 			 			 -- wird das Sync-Flag gesetzt
				end if;
			else -- Änderung am Eingang
				Sync := '0'; -- Sync-Flag zurücksetzen
				if (Zeit_ohne_Aenderung > Zeit_ohne_Aenderung_max) then     -- neuer Maximalwert?
					Zeit_ohne_Aenderung_max := Zeit_ohne_Aenderung; -- wenn ja, Variable aktualisieren
				end if;
				Zeit_ohne_Aenderung := 0; -- Messwert zurücksetzen
				
				--Maximum nach N Signaländerungen übernehmen
				SignalAenderungen := SignalAenderungen + 1;
				if(SignalAenderungen = AenderungenBisUebernahme) then
					Sync_Laenge := Zeit_ohne_Aenderung_max;
					Sync_ErkennungsLaenge := Sync_Laenge/2;
					Zeit_ohne_Aenderung_max :=0;
					SignalAenderungen := 0;
				end if;
				------------
			end if;
			
			----------------------------
			-- Dann Bit-Takt erzeugen --
			----------------------------
			
			-- [Frame- bzw. Bitlänge ermitteln]
			if (Sync_Letzer_Wert='1' and Sync='0') then --fallende Flanke an Sync => Frame-Anfang
				Sync_FrameLaenge := Sync_FrameLaengeZaehler; --Framelänge übernehmen
				Sync_BitLaenge := Sync_FrameLaenge/256;    --256 Bit/Frame
				--Zähler zurücksetzen:
				Sync_FrameLaengeZaehler :=0;                 
				Bitlaengen_Zaehler :=0;
				ADAT_Takt:= '0'; --definierter Anfangspegel für das Taktsignal
			else
				Sync_FrameLaengeZaehler := Sync_FrameLaengeZaehler + 1; --Framelänge ermitteln
			end if;
			
			-- [Bit-Takt erzeugen]
			if ADAT_In_Letzter_Wert /= In_ADAT then --irgendeine Flanke
				if Sync='0' then --Taktflanke bei Signalwechsel auf der ADAT-Leitung nur dann erzeugen, wenn wir uns nicht im Sync-Modus befinden 
									  --(verhindert Blödsinn am Anfang es Frames) TODO: stimmt das noch?
					if Bitlaengen_Zaehler >= (Sync_BitLaenge/8) then --Mindestens ein Achtel der Zeit für ein Bit abgelaufen
																							--Hälfte (Mitte des Bits) des Viertels (Phasenangleich, aber nicht um jeden Preis)
						ADAT_Takt := not ADAT_Takt; --Takt ausgeben
					end if;
				end if;
				Bitlaengen_Zaehler :=0; --Phasenkorrektur, tritt spätestens nach 5 (1Wechsel+4gleichbleibende Bits) Bits auf (Bitstuffing)
			else --keine Flanke aufgetreten
			   ------------------------------------------------------------------
				-- Durch die Zweiteilige Abfrage von BitLaenge/2 und Bitlaenge  --
				-- erhöht sich die Zeitliche Auflösung im Vergleich zur Abfrage --
				-- von BitLaenge/2 und sofortigem Rücksetzen							 --
				------------------------------------------------------------------
				if (Bitlaengen_Zaehler = Sync_BitLaenge/2) then
					ADAT_Takt := not ADAT_Takt; --Takt ausgeben
				end if;
				if (Bitlaengen_Zaehler >= Sync_BitLaenge) then --Zeit für ein Bit abgelaufen
					ADAT_Takt := not ADAT_Takt; --Takt ausgeben
					Bitlaengen_Zaehler :=0;
				else
					Bitlaengen_Zaehler := Bitlaengen_Zaehler + 1; --Bit-Zeit hochzählen
				end if;
			end if;
			
			--Verzögerte "Signale"
			ADAT_In_Letzter_Wert  := In_ADAT;
			Sync_Letzer_Wert      := Sync;
			ADAT_Takt_Letzer_Wert := ADAT_Takt;
			
			--Ausgänge
			Out_ADAT_Clock <= ADAT_Takt;
			Frame_Sync 		<= Sync;
			
		end if;--clk
   end process;

end Verhalten;


