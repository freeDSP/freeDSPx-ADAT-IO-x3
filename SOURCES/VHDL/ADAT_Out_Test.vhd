----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:59:05 11/11/2013 
-- Design Name: 
-- Module Name:    ADAT_Out_Test - Behavioral 
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

entity ADAT_Out_Test is
	generic (AdatSchnittstellen : natural := 3; --Konstanten sind hier nicht erlaubt, über den Default-Wert der Generics geht es aber auch
				PUFFERLAENGE : natural := 2);
	Port ( in_Platinentakt: in std_logic;
			 Out_ADAT : out bit_vector(0 to AdatSchnittstellen-1) := (others => '0');
			 --Debug_Audio: out bit_vector(23 downto 0);
			 Debug_Schneller_Takt: out std_logic;
			 Debug_ADAT_Takt: out std_logic;
			 
			 Out_PufferVoll : out bit := '0';
			 Out_PufferLeer : out bit := '1';
			 Out_PufferUeberlauf : out bit := '0';
			 Out_PufferUnterlauf : out bit := '0';
			 
			 Out_EsLebt : out bit :='0'
			);
end ADAT_Out_Test;

architecture Behavioral of ADAT_Out_Test is
	--komponenten
--	COMPONENT SchnellerTakt
--	PORT(
--		CLKIN_IN : IN std_logic;          
--		CLKFX_OUT : OUT std_logic;
--		CLK0_OUT : OUT std_logic
--		);
--	END COMPONENT;

	
	
	COMPONENT EnkoderTestClock
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic
		);
	END COMPONENT;
	
	Component ADAT_Enkoder
	generic( AdatSchnittstellen : integer := 3);
	Port ( ADAT_Frame_Sync: in bit;
			  ADAT_Bit_Clock: in std_logic;
           Daten : in ADAT_Daten_Array(0 to AdatSchnittstellen-1);
			  DatenUebernommen : out bit;
			  Out_ADAT : out bit_vector(0 to AdatSchnittstellen-1) := (others => '0')
			  );
	end component;
	
	COMPONENT DynamischerADATPuffer_BRAM
	 generic (PUFFERLAENGE : integer := 2; --Wie viele Elemente soll der Puffer maximal aufnehmen können?
				 PUFFERBREITE : integer := 1 --Wie viele ADAT-Schnittstellen?
				 ); 
    PORT(
			Reset : in bit;
			clk : in std_logic;
         Eingang_NeueDatenAngekommen : in  bit;
         Eingang : in ADAT_Daten_Array(0 to AdatSchnittstellen-1);
         PufferVoll : OUT  bit;
         PufferLeer : OUT  bit;
         PufferUeberlauf : OUT  bit;
         PufferUnterlauf : OUT  bit;
         Ausgang_NaechsterDatensatz : IN  bit;
         Ausgang : OUT  ADAT_Daten_Array(0 to AdatSchnittstellen-1)
        );
    END COMPONENT;
	--signale
	--signal Schneller_Takt : bit;
	signal Schneller_Takt_std : std_logic;
	--signal ADAT_Bit_Clock : bit;
	signal ADAT_Bit_Clock_std : std_logic;
	signal ADAT_Frame_Sync : bit;	
	signal PufferReset : bit;
	signal PufferNeueDaten: bit;
	signal Puffer_Enkoder_Daten: ADAT_Daten_Array(0 to AdatSchnittstellen-1);
	signal Enkoder_Puffer_DatenUebernommen: bit;
	signal PufferDaten: ADAT_Daten_Array(0 to AdatSchnittstellen-1);
	
begin
	Inst_EnkoderTestClock: EnkoderTestClock
	PORT MAP(
		CLKIN_IN => in_Platinentakt, --dcm eingang
		CLKFX_OUT => ADAT_Bit_Clock_std, --dcm ausgang
		CLK0_OUT => open 
		);
		--ADAT_Bit_Clock <= to_bit(ADAT_Bit_Clock_std);
		
--	Inst_SchnellerTakt: SchnellerTakt PORT MAP(
--		CLKIN_IN => Platinentakt ,
--		CLKFX_OUT => Schneller_Takt_std,
--		CLK0_OUT => open
--		);

	
	
	Inst_ADAT_Enkoder: ADAT_Enkoder
	generic map(AdatSchnittstellen => AdatSchnittstellen)
	PORT MAP(
		ADAT_Frame_Sync => ADAT_Frame_Sync,
		ADAT_Bit_Clock => ADAT_Bit_Clock_std,
		Daten => Puffer_Enkoder_Daten, --PufferDaten,
		DatenUebernommen => Enkoder_Puffer_DatenUebernommen,
		Out_ADAT => Out_ADAT
		);
	
	Inst_DynamischerADATPuffer: DynamischerADATPuffer_BRAM
	generic map (PUFFERLAENGE => PUFFERLAENGE,
				    PUFFERBREITE => AdatSchnittstellen
				    )
	PORT MAP(
		clk => ADAT_Bit_Clock_std,--Schneller_Takt_std,
		Reset => PufferReset,
		Eingang_NeueDatenAngekommen  => PufferNeueDaten,
		Eingang  => PufferDaten,
		PufferVoll  => Out_PufferVoll,
		PufferLeer  => Out_PufferLeer,
		PufferUeberlauf  => Out_PufferUeberlauf,
		PufferUnterlauf  => Out_PufferUnterlauf,
		Ausgang_NaechsterDatensatz  => Enkoder_Puffer_DatenUebernommen,
		Ausgang  => Puffer_Enkoder_Daten
		);
		
--	ADAT_BitClock: process(Schneller_Takt_std)
--		variable i:integer := 0;
--	begin
--		if rising_edge(Schneller_Takt_std) then
--			i:=i+1;
--			if i=13 then 
--				ADAT_Bit_Clock_std<='H';
--			end if;
--			if i=27 then
--				ADAT_Bit_Clock_std<='L';
--				i:=0;
--			end if;
--		end if;
--	end process;
	
	Debug_ADAT_Takt <= ADAT_Bit_Clock_std;
	
	DreieckSignal: process(ADAT_Bit_Clock_std)
		variable wert : integer range 0 to 47 := 0; --ergibt 500Hz bei 48Khz Abtastrate (48 x hochzählen + 48x runterzählen)
		variable steigend: boolean := true;
		variable bits : integer range 0 to 255 := 0;
		variable intervall : integer := 1;
		variable i : integer:=0;
	begin
		if rising_edge(ADAT_Bit_Clock_std) then
			bits := (bits+1) mod 256;
			if bits=255 then
				i := i + 1;
				if i=48000 then
					intervall:=(intervall + 1);
					if intervall = 4 then intervall:=0; end if;
					i:=0;
				end if;
				if steigend=true then
					wert := wert + 1 + intervall;
				else
					wert := wert - 1 - intervall;
				end if;
				--ggf. Richtung umkehren
				if wert <= 0 then
					steigend := true;
				elsif wert >= 47 then
					steigend := false;
				end if;
				PufferDaten(0).UserBits <= "0000"; 
				if    wert= 0 then	PufferDaten(0).Kanaele(0) <= "011111111111111111111111"; --Vorzeichenbehaftete Werte für eine Dreiecksignal
				elsif wert= 1 then	PufferDaten(0).Kanaele(0) <= "011110101010101010101010";
				elsif wert= 2 then	PufferDaten(0).Kanaele(0) <= "011101010101010101010100";
				elsif wert= 3 then	PufferDaten(0).Kanaele(0) <= "011011111111111111111111";
				elsif wert= 4 then	PufferDaten(0).Kanaele(0) <= "011010101010101010101010";
				elsif wert= 5 then	PufferDaten(0).Kanaele(0) <= "011001010101010101010100";
				elsif wert= 6 then	PufferDaten(0).Kanaele(0) <= "010111111111111111111111";
				elsif wert= 7 then	PufferDaten(0).Kanaele(0) <= "010110101010101010101010";
				elsif wert= 8 then	PufferDaten(0).Kanaele(0) <= "010101010101010101010101";
				elsif wert= 9 then	PufferDaten(0).Kanaele(0) <= "010011111111111111111111";
				elsif wert=10 then	PufferDaten(0).Kanaele(0) <= "010010101010101010101010";
				
				elsif wert=11 then	PufferDaten(0).Kanaele(0) <= "010001010101010101010101";
				elsif wert=12 then	PufferDaten(0).Kanaele(0) <= "001111111111111111111111";
				elsif wert=13 then	PufferDaten(0).Kanaele(0) <= "001110101010101010101010";
				elsif wert=14 then	PufferDaten(0).Kanaele(0) <= "001101010101010101010101";
				elsif wert=15 then	PufferDaten(0).Kanaele(0) <= "001011111111111111111111";
				elsif wert=16 then	PufferDaten(0).Kanaele(0) <= "001010101010101010101010";
				elsif wert=17 then	PufferDaten(0).Kanaele(0) <= "001001010101010101010101";
				elsif wert=18 then	PufferDaten(0).Kanaele(0) <= "000111111111111111111111";
				elsif wert=19 then	PufferDaten(0).Kanaele(0) <= "000110101010101010101010";
				elsif wert=20 then	PufferDaten(0).Kanaele(0) <= "000101010101010101010101";
				elsif wert=21 then	PufferDaten(0).Kanaele(0) <= "000011111111111111111111";
				elsif wert=22 then	PufferDaten(0).Kanaele(0) <= "000010101010101010101010";
				elsif wert=23 then	PufferDaten(0).Kanaele(0) <= "000001010101010101010101";
				elsif wert=24 then	PufferDaten(0).Kanaele(0) <= "111111111111111111111111";
				elsif wert=25 then	PufferDaten(0).Kanaele(0) <= "111110101010101010101010";
				elsif wert=26 then	PufferDaten(0).Kanaele(0) <= "111101010101010101010101";
				elsif wert=27 then	PufferDaten(0).Kanaele(0) <= "111100000000000000000000";
				elsif wert=28 then	PufferDaten(0).Kanaele(0) <= "111010101010101010101010";
				elsif wert=29 then	PufferDaten(0).Kanaele(0) <= "111001010101010101010101";	
				elsif wert=30 then	PufferDaten(0).Kanaele(0) <= "111000000000000000000000";
				elsif wert=31 then	PufferDaten(0).Kanaele(0) <= "110110101010101010101010";
				elsif wert=32 then	PufferDaten(0).Kanaele(0) <= "110101010101010101010101";
				elsif wert=33 then	PufferDaten(0).Kanaele(0) <= "110100000000000000000000";
				elsif wert=34 then	PufferDaten(0).Kanaele(0) <= "110010101010101010101010";
				elsif wert=35 then	PufferDaten(0).Kanaele(0) <= "110001010101010101010101";
				elsif wert=36 then	PufferDaten(0).Kanaele(0) <= "110000000000000000000000";
				elsif wert=37 then	PufferDaten(0).Kanaele(0) <= "101110101010101010101010";
				elsif wert=38 then	PufferDaten(0).Kanaele(0) <= "101101010101010101010101";
				elsif wert=39 then	PufferDaten(0).Kanaele(0) <= "101100000000000000000000";
				elsif wert=40 then	PufferDaten(0).Kanaele(0) <= "101010101010101010101010";
				elsif wert=41 then	PufferDaten(0).Kanaele(0) <= "101001010101010101010101";
				elsif wert=42 then	PufferDaten(0).Kanaele(0) <= "101000000000000000000000";
				elsif wert=43 then	PufferDaten(0).Kanaele(0) <= "100110101010101010101011";
				elsif wert=44 then	PufferDaten(0).Kanaele(0) <= "100101010101010101010101";
				elsif wert=45 then	PufferDaten(0).Kanaele(0) <= "100100000000000000000000";
				elsif wert=46 then	PufferDaten(0).Kanaele(0) <= "100010101010101010101011";
				elsif wert=47 then	PufferDaten(0).Kanaele(0) <= "100001010101010101010101";
				--elsif wert=48 then	PufferDaten(0).Kanaele(0) <= "100000000000000000000000";--kommt nie vor, entspräche dem minimalwert
				end if;		
				PufferDaten(1).Kanaele(1)<=PufferDaten(0).Kanaele(0);--mehr Kanäle testen
				PufferDaten(2).Kanaele(2)<=PufferDaten(0).Kanaele(0);
			
				
				--Debug_Audio <= PufferDaten(0).Kanaele(0);
				PufferNeueDaten <= not PufferNeueDaten;
			end if;
		end if;
	end process;
	
	Lebenszeichen: process (in_Platinentakt)
	variable i : integer := 0;
	variable wert : bit := '0';
	begin
		if rising_edge(in_Platinentakt) then
			if i<25000000 then
				i:=i+1;
			else
				i:=0;
				wert := not wert;
				Out_EsLebt<= wert;
			end if;
		end if;
	end process;

	Debug_Schneller_Takt <= Schneller_Takt_std;
end Behavioral;

