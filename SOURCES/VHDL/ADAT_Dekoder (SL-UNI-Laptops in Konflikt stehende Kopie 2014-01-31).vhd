--####################################
--# Autor: Simon Lohmann # 2013/2014 #
--####################################

--################
--# ADAT_Dekoder #
--####################################################################
--# Dekodiert eingehende ADAT-Signale und pr�ft diese �ber die       #
--# konstanten Bits (Bitstuffing & Sync.) auf Fehler.                #
--####################################################################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ADAT.all;

entity ADAT_Dekoder is
	generic (AdatSchnittstellen : integer := 3);--Anzahl der Adat-Schnittstellen, von denen Daten entgegen genommen werden sollen
	
	Port   (ADAT_Takt		 : in std_logic;
			  ADAT_Sync		 : in bit;
			  -- Daten-Eing�nge
			  In_ADAT 		 : in bit_vector(0 to AdatSchnittstellen-1);
			  
			  -- Daten-Ausgang			  
			  Out_Daten 	 : out ADAT_Daten_Array(0 to AdatSchnittstellen-1);
			  Out_FrameOK    : out bit_vector(0 to AdatSchnittstellen-1);
			  Out_NeueDaten  : out bit;
			  Debug_Bitstuffing: out bit_vector(0 to 7)
			  );
end ADAT_Dekoder;

architecture Verhalten of ADAT_Dekoder is
begin
	Dekodierung: process (ADAT_Takt)
	   --Verz�gerte Signale
		variable ADAT_Sync_Letzer_Wert: bit;
		variable ADAT_Takt_Letzer_Wert: std_logic;
		
		--Daten lesen
		variable ADAT_Frame : ADAT_Frame_Array(0 to AdatSchnittstellen-1);
		variable BitZaehler : natural range 0 to 255 := 0;
		variable Letztes_Bit: bit_vector(0 to AdatSchnittstellen-1);
		variable NeueDaten  : bit := '0';
		
		variable FrameOK : bit := '0';
	begin
		if rising_edge(ADAT_Takt) then
			------------------
			--Daten einlesen--
			------------------
			
			--[Frame-Sync]--
			if (ADAT_Sync_Letzer_Wert='1' and ADAT_Sync='0') then --fallende Flanke an Sync => Frame-Anfang
				BitZaehler := 0; --Damit der korrekte Empfang schon beim Einsetzen des korrekten ADAT-Taktes beginnt
			end if;
			ADAT_Sync_Letzer_Wert := ADAT_Sync;

			--[NRZI]--
			for i in 0 to AdatSchnittstellen-1 loop --Aufgrund der Datenstruktur ist hier elementweises Vorgehen n�tig
				--ADAT_Frame(i)(BitZaehler) := (Letztes_Bit(i) xor IN_ADAT(i)); --NRZI: 1 wenn wechsel, 0 wenn gleich
				ADAT_Frame(i) := ADAT_Frame(i)(1 to 255) & (Letztes_Bit(i) xor In_ADAT(i)); --NRZI: 1 wenn wechsel, 0 wenn gleich   --#�quivalent, spart aber 334 Slices (bei 2 Kan�len)
			end loop;
			Letztes_Bit := IN_ADAT; -- f�r nrzi merken
					
			--[Frame Vollst�ndig]--
			if BitZaehler = 255 then --Frame Komplett empfangen?
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
				
				--FrameOK := '1'; --Wegen der Und-Verkn�pfung zun�chst auf '1' setzen
				
				for i in 0 to AdatSchnittstellen-1 loop
					Out_Daten(i).UserBits <= ADAT_Frame(i)(1 to 4); 
					
					Out_Daten(i).Kanaele(0) <= ADAT_Frame(i)(6   to 9  ) & ADAT_Frame(i)(11  to 14 ) & ADAT_Frame(i)(16  to 19 ) & ADAT_Frame(i)(21  to 24 ) & ADAT_Frame(i)(26  to 29 ) & ADAT_Frame(i)(31  to 34 );
					Out_Daten(i).Kanaele(1) <= ADAT_Frame(i)(36  to 39 ) & ADAT_Frame(i)(41  to 44 ) & ADAT_Frame(i)(46  to 49 ) & ADAT_Frame(i)(51  to 54 ) & ADAT_Frame(i)(56  to 59 ) & ADAT_Frame(i)(61  to 64 );
					Out_Daten(i).Kanaele(2) <= ADAT_Frame(i)(66  to 69 ) & ADAT_Frame(i)(71  to 74 ) & ADAT_Frame(i)(76  to 79 ) & ADAT_Frame(i)(81  to 84 ) & ADAT_Frame(i)(86  to 89 ) & ADAT_Frame(i)(91  to 94 );
					Out_Daten(i).Kanaele(3) <= ADAT_Frame(i)(96  to 99 ) & ADAT_Frame(i)(101 to 104) & ADAT_Frame(i)(106 to 109) & ADAT_Frame(i)(111 to 114) & ADAT_Frame(i)(116 to 119) & ADAT_Frame(i)(121 to 124);
					Out_Daten(i).Kanaele(4) <= ADAT_Frame(i)(126 to 129) & ADAT_Frame(i)(131 to 134) & ADAT_Frame(i)(136 to 139) & ADAT_Frame(i)(141 to 144) & ADAT_Frame(i)(146 to 149) & ADAT_Frame(i)(151 to 154);
					Out_Daten(i).Kanaele(5) <= ADAT_Frame(i)(156 to 159) & ADAT_Frame(i)(161 to 164) & ADAT_Frame(i)(166 to 169) & ADAT_Frame(i)(171 to 174) & ADAT_Frame(i)(176 to 179) & ADAT_Frame(i)(181 to 184);
					Out_Daten(i).Kanaele(6) <= ADAT_Frame(i)(186 to 189) & ADAT_Frame(i)(191 to 194) & ADAT_Frame(i)(196 to 199) & ADAT_Frame(i)(201 to 204) & ADAT_Frame(i)(206 to 209) & ADAT_Frame(i)(211 to 214);
					Out_Daten(i).Kanaele(7) <= ADAT_Frame(i)(216 to 219) & ADAT_Frame(i)(221 to 224) & ADAT_Frame(i)(226 to 229) & ADAT_Frame(i)(231 to 234) & ADAT_Frame(i)(236 to 239) & ADAT_Frame(i)(241 to 244);
					
--					if (ADAT_Frame(i)(  5)='1') then-- and ADAT_Frame(i)( 10)='1' and ADAT_Frame(i)( 15)='1') then
--						Out_FrameOK(i) <= '1';
--					else
--						Out_FrameOK(i) <= '0';
--					end if;
					--Out_FrameOK(i) <= ADAT_Frame(i)(5);
--					Out_FrameOK(i) <=  '1' when (ADAT_Frame(i)(  5)='1' and ADAT_Frame(i)( 10)='1' and ADAT_Frame(i)( 15)='1') 
--					else '0';--and ADAT_Frame(i)( 15);-- and ADAT_Frame(i)( 20) and ADAT_Frame(i)( 25);
--											 and ADAT_Frame(i)( 30) and ADAT_Frame(i)( 35) and ADAT_Frame(i)( 40) and ADAT_Frame(i)( 45) and ADAT_Frame(i)( 50) and ADAT_Frame(i)( 55)
--											 and ADAT_Frame(i)( 60) and ADAT_Frame(i)( 65) and ADAT_Frame(i)( 70) and ADAT_Frame(i)( 75) and ADAT_Frame(i)( 80) and ADAT_Frame(i)( 85)
--											 and ADAT_Frame(i)( 90) and ADAT_Frame(i)( 95) and ADAT_Frame(i)(100) and ADAT_Frame(i)(105) and ADAT_Frame(i)(110) and ADAT_Frame(i)(115)
--											 and ADAT_Frame(i)(120) and ADAT_Frame(i)(125) and ADAT_Frame(i)(130) and ADAT_Frame(i)(135) and ADAT_Frame(i)(140) and ADAT_Frame(i)(145)
--											 and ADAT_Frame(i)(150) and ADAT_Frame(i)(155) and ADAT_Frame(i)(160) and ADAT_Frame(i)(165) and ADAT_Frame(i)(170) and ADAT_Frame(i)(175)
--											 and ADAT_Frame(i)(180) and ADAT_Frame(i)(185) and ADAT_Frame(i)(190) and ADAT_Frame(i)(195) and ADAT_Frame(i)(200) and ADAT_Frame(i)(205)
--											 and ADAT_Frame(i)(210) and ADAT_Frame(i)(215) and ADAT_Frame(i)(220) and ADAT_Frame(i)(225) and ADAT_Frame(i)(230) and ADAT_Frame(i)(235)
--											 and ADAT_Frame(i)(240) ;--and ADAT_Frame(i)(245); --Bitstuffing
----											 and not (ADAT_Frame(i)(246) or ADAT_Frame(i)(247) or ADAT_Frame(i)(248) or ADAT_Frame(i)(249) or ADAT_Frame(i)(250) 
----													 or ADAT_Frame(i)(251) or ADAT_Frame(i)(252) or ADAT_Frame(i)(253) or ADAT_Frame(i)(254) );--or ADAT_Frame(i)(255) );
				end loop;
				Out_FrameOK(0) <= ADAT_Frame(0)(5);
				Out_FrameOK(1) <= ADAT_Frame(1)(5);
				Out_FrameOK(2) <= ADAT_Frame(2)(5);
				Debug_Bitstuffing <= ADAT_Frame(0)(5) 
										 & ADAT_Frame(0)(5) 
										 & ADAT_Frame(0)(5) 
										 & ADAT_Frame(1)(5) 
										 & ADAT_Frame(1)(5) 
										 & ADAT_Frame(1)(5) 
										 & ADAT_Frame(2)(5) 
										 & ADAT_Frame(2)(5);
				--if FrameOK='1' then
					NeueDaten := not NeueDaten; -- es sind neue Daten da!
				--end if;
				--Out_FrameOK(i) <= FrameOK;
			else
				BitZaehler := BitZaehler + 1;
			end if;
			
			--Ausg�nge
			Out_NeueDaten  <= NeueDaten;
		end if;
   end process;

end Verhalten;

