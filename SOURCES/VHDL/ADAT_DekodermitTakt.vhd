----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:46:34 10/26/2013 
-- Design Name: 
-- Module Name:    ADAT_Dekoder - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADAT_Dekoder_alt is
	generic (AdatSchnittstellen : integer := 3);--Anzahl der Adat-Schnittstellen, von denen Daten entgegen genommen werden sollen
	Port  ( clk 			  : in std_logic;
			  -- Daten-Eingang
			  In_ADAT 		  : in bit_vector(0 to AdatSchnittstellen-1);
			  
			  -- Daten-Ausgang
			  Out_Daten 	  : out ADAT_Daten;
			  Out_FrameOK    : out bit;
			  
			  -- Takt-Ausgang
			  Out_ADAT_Clock : out std_logic;
			  Out_NeueDaten  : out bit;
			  Frame_Sync     : out bit := '0'--#;
			  
			  -- Debug-Signale
			  --#Debug_Sync_Len : out natural range 0 to 1023 := 0;
			  --#Debug_Sync_BitLaenge : out natural range 0 to 1023 := 0;
			  --#Debug_ADAT_BitNummer : out natural range 0 to 255 := 0;
			  --#Debug_Letztes_Bit: out bit;
           --#Out_Raw_Audio  : out bit_vector(0 to 255);
			  --#Debug_Takt_BitLaengeZaehler : out natural range 0 to 1023 :=0;
			  --#Debug_Takt_Sync_letztesBit : out bit
			  );
end ADAT_Dekoder;

architecture Verhalten of ADAT_Dekoder_alt is
	--signal Intern_ADAT_Clock : bit;
begin
	Sync_Erkennung: process (clk)
	   --Verzögerte Signale
		variable ADAT_In_Letzter_Wert: bit_vector(0 to AdatSchnittstellen-1);
		variable Sync_Letzer_Wert: bit;
		variable ADAT_Takt_Letzer_Wert: std_logic;
		
		--Sync
		constant AenderungenBisUebernahme: natural := 200;

		variable Zeit_ohne_Aenderung: natural range 0 to 1023 := 0;
		variable Zeit_ohne_Aenderung_max: natural range 0 to 1023 := 0;
		variable SignalAenderungen: natural range 0 to 300 := 0;
		variable Sync_Laenge: natural range 0 to 1023 := 0;
		variable Sync_ErkennungsLaenge:natural range 0 to 511 := 0;
		variable Sync: bit;
		
		--Bit-Takt
		variable Sync_FrameLaengeZaehler: natural range 0 to 1023:=1;
		variable Sync_FrameLaenge: natural range 1 to 1024:=1;
		variable Bitlaengen_Zaehler: natural range 0 to 1023:=1;
		variable Sync_BitLaenge: natural range 1 to 4:=1; --Sync_FrameLaenge/256

		variable ADAT_Takt: std_logic;
		
		--Daten lesen
		variable ADAT_Frame : bit_vector (0 to 255);
		variable BitZaehler : natural range 0 to 255 := 0;
		variable Letztes_Bit: bit;
		variable NeueDaten  : bit := '0';
		
		variable FrameOK : bit := '0';
	begin
		if rising_edge(clk) then --steigende Flanke auf CLK (Wegen Synchronisierung im FPGA)
			------------------------
			-- Erst Sync erkennen --
			------------------------
			if (In_ADAT = ADAT_In_Letzter_Wert) then -- Dauer ohne Änderungen am Eingang
				Zeit_ohne_Aenderung := Zeit_ohne_Aenderung + 1; -- ...im ADAT-Signal messen
				if (Zeit_ohne_Aenderung >= Sync_Erkennungslaenge) then -- Wenn die Mindestdauer zur Erkennung des Sync-Signals erreicht ist,
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
				--#Debug_Sync_Len <= Sync_Laenge;
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
				ADAT_Takt:= 'L'; --definierter Anfangspegel für das Taktsignal
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
			
			------------------
			--Daten einlesen--
			------------------
			if (Sync_Letzer_Wert='1' and Sync='0') then --fallende Flanke an Sync => Frame-Anfang
				BitZaehler := 0; --Damit der korrekte Empfang schon beim Einsetzen des korrekten ADAT-Taktes beginnt
			end if;
			if (ADAT_Takt/=ADAT_Takt_Letzer_Wert) then --Flanke

				if (ADAT_Takt='1') then --steigende Flanke
					ADAT_Frame(BitZaehler) := (Letztes_Bit xor IN_ADAT); --NRZI: 1 wenn wechsel, 0 wenn gleich
					
					Letztes_Bit := IN_ADAT; -- für nrzi merken
					--#Debug_Letztes_Bit <= IN_ADAT; --DEBUG
					
					if BitZaehler = 255 then --Frame Komplett empfangen?
						--#Out_Raw_Audio <= ADAT_Frame;
						BitZaehler := 0;
						--Daten extrahieren
						
						--ADAT-Frame:
						-- 0  1  2  3  4
						-- BS U  U  U  U  (UserBits)
						
						-- 5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34
						-- BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   (Kanal 0)
						
						-- 35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64
						-- BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   (Kanal 1)
						
						-- 65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94
						-- BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   (Kanal 2)
						
						-- 95  96  97  98  99  100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124
						-- BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   (Kanal 3)
						
						-- 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154
						-- BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   (Kanal 4)
						
						-- 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184
						-- BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   (Kanal 5)
						
						-- 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214
						-- BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   (Kanal 6)
						
						-- 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244
						-- BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   BS  0   0   0   0   (Kanal 7)
						
						-- 245 246 247 248 249 250 251 252 253 254 255
						-- BS  SY  SY  SY  SY  SY  SY  SY  SY  SY  SY


						Out_Daten.UserBits <= ADAT_Frame(1 to 4); 
						
						Out_Daten.Kanaele(0) <= ADAT_Frame(6   to 9  ) & ADAT_Frame(11  to 14 ) & ADAT_Frame(16  to 19 ) & ADAT_Frame(21  to 24 ) & ADAT_Frame(26  to 29 ) & ADAT_Frame(31  to 34 );
						Out_Daten.Kanaele(1) <= ADAT_Frame(36  to 39 ) & ADAT_Frame(41  to 44 ) & ADAT_Frame(46  to 49 ) & ADAT_Frame(51  to 54 ) & ADAT_Frame(56  to 59 ) & ADAT_Frame(61  to 64 );
						Out_Daten.Kanaele(2) <= ADAT_Frame(66  to 69 ) & ADAT_Frame(71  to 74 ) & ADAT_Frame(76  to 79 ) & ADAT_Frame(81  to 84 ) & ADAT_Frame(86  to 89 ) & ADAT_Frame(91  to 94 );
						Out_Daten.Kanaele(3) <= ADAT_Frame(96  to 99 ) & ADAT_Frame(101 to 104) & ADAT_Frame(106 to 109) & ADAT_Frame(111 to 114) & ADAT_Frame(116 to 119) & ADAT_Frame(121 to 124);
						Out_Daten.Kanaele(4) <= ADAT_Frame(126 to 129) & ADAT_Frame(131 to 134) & ADAT_Frame(136 to 139) & ADAT_Frame(141 to 144) & ADAT_Frame(146 to 149) & ADAT_Frame(151 to 154);
						Out_Daten.Kanaele(5) <= ADAT_Frame(156 to 159) & ADAT_Frame(161 to 164) & ADAT_Frame(166 to 169) & ADAT_Frame(171 to 174) & ADAT_Frame(176 to 179) & ADAT_Frame(181 to 184);
						Out_Daten.Kanaele(6) <= ADAT_Frame(186 to 189) & ADAT_Frame(191 to 194) & ADAT_Frame(196 to 199) & ADAT_Frame(201 to 204) & ADAT_Frame(206 to 209) & ADAT_Frame(211 to 214);
						Out_Daten.Kanaele(7) <= ADAT_Frame(216 to 219) & ADAT_Frame(221 to 224) & ADAT_Frame(226 to 229) & ADAT_Frame(231 to 234) & ADAT_Frame(236 to 239) & ADAT_Frame(241 to 244);
						
						FrameOK :=     ADAT_Frame(  0) and ADAT_Frame(  5) and ADAT_Frame( 10) and ADAT_Frame( 15) and ADAT_Frame( 20) and ADAT_Frame( 25)
									  and ADAT_Frame( 30) and ADAT_Frame( 35)	and ADAT_Frame( 40) and ADAT_Frame( 45) and ADAT_Frame( 50) and ADAT_Frame( 55)
									  and ADAT_Frame( 60) and ADAT_Frame( 65)	and ADAT_Frame( 70) and ADAT_Frame( 75) and ADAT_Frame( 80) and ADAT_Frame( 85)
									  and ADAT_Frame( 90) and ADAT_Frame( 95) and ADAT_Frame(100) and ADAT_Frame(105) and ADAT_Frame(110) and ADAT_Frame(115)
									  and ADAT_Frame(120) and ADAT_Frame(125) and ADAT_Frame(130) and ADAT_Frame(135) and ADAT_Frame(140) and ADAT_Frame(145)
									  and ADAT_Frame(150) and ADAT_Frame(155) and ADAT_Frame(160) and ADAT_Frame(165) and ADAT_Frame(170) and ADAT_Frame(175)
									  and ADAT_Frame(180) and ADAT_Frame(185) and ADAT_Frame(190) and ADAT_Frame(195) and ADAT_Frame(200) and ADAT_Frame(205)
									  and ADAT_Frame(210) and ADAT_Frame(215) and ADAT_Frame(220) and ADAT_Frame(225) and ADAT_Frame(230) and ADAT_Frame(235)
									  and ADAT_Frame(240) and ADAT_Frame(245) --Bitstuffing
									  and not (ADAT_Frame(246) or ADAT_Frame(247) or ADAT_Frame(248) or ADAT_Frame(249) or ADAT_Frame(250) 
											  or ADAT_Frame(251) or ADAT_Frame(252) or ADAT_Frame(253) or ADAT_Frame(254) or ADAT_Frame(255) );
						
						if FrameOK='1' then
							NeueDaten := not NeueDaten;
						--else
							--nix
						end if;
						Out_FrameOK <= FrameOK;
					else
						BitZaehler := BitZaehler + 1;
					end if;
				end if;
			end if;
			--Verzögerte "Signale"
			ADAT_In_Letzter_Wert  := In_ADAT;
			Sync_Letzer_Wert      := Sync;
			ADAT_Takt_Letzer_Wert := ADAT_Takt;
			
			--Ausgänge
			Out_ADAT_Clock <= ADAT_Takt;
			Out_NeueDaten  <= NeueDaten;
			Frame_Sync 		<= Sync;
			
			--Debug-Ausgänge
			--#Debug_ADAT_BitNummer 		 <= BitZaehler;
			--#Debug_Sync_BitLaenge 		 <= Zeit_ohne_Aenderung;
			--#Debug_Takt_BitLaengeZaehler <= Bitlaengen_Zaehler;
			--#Debug_Takt_Sync_letztesBit  <= Sync_Letzer_Wert;
			
		end if;--clk
   end process;

end Verhalten;

