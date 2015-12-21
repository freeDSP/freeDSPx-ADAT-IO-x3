--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package ADAT is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;

	type Audio8x24 is array (0 to 7) of bit_vector(23 downto 0);
	
	type ADAT_Daten is record
		Kanaele : Audio8x24;
		UserBits : bit_vector(3 downto 0);
	end record ADAT_Daten;
	
	constant ADAT_DATENMENGE : natural := (192+4);
	
	type ADAT_Daten_Array is array (natural range <>) of ADAT_Daten;
	
	type ADAT_Frame_Array is array (natural range <>) of bit_vector(0 to 255);
--	type ADAT_Daten_Bitvector_Array is array (natural range <>) of bit_vector(0 to ADAT_DATENMENGE-1);
	
	type AdatBitDelay is array (natural range <>) of natural range 0 to 255;	
	
	function AdatDatenArray_TO_Bitvector (Datenarray : in ADAT_Daten_Array) return bit_vector;
	--function Bitvector_TO_AdatDatenArray (Bitvector : in bit_vector; Kanaele : in natural) return ADAT_Daten_Array;
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
	type bytearray is array (natural range <>) of natural range 0 to 255;
	type tLeitungsindex is array (natural range <>) of natural range 0 to 1;
	type ADATLangsam is array (natural range <>) of bit_vector(0 to 1);
end ADAT;

package body ADAT is

	function AdatDatenArray_TO_Bitvector (Datenarray : in ADAT_Daten_Array) return bit_vector is
		variable ergebnis : bit_vector(Datenarray'length*ADAT_DATENMENGE-1 downto 0);
	begin
		for kanal in Datenarray'range loop
			ergebnis((kanal+1)*ADAT_DATENMENGE-1 downto kanal*ADAT_DATENMENGE) :=
										  Datenarray(kanal).UserBits
										& Datenarray(kanal).Kanaele(7) & Datenarray(kanal).Kanaele(6)& Datenarray(kanal).Kanaele(5)& Datenarray(kanal).Kanaele(4)
										& Datenarray(kanal).Kanaele(3) & Datenarray(kanal).Kanaele(2)& Datenarray(kanal).Kanaele(1)& Datenarray(kanal).Kanaele(0); 
		end loop;
		return ergebnis;
	end function;
	
	
--	function Bitvector_TO_AdatDatenArray (Bitvector : in bit_vector; Kanaele : in natural) return ADAT_Daten_Array is
--		variable ergebnis : ADAT_Daten_Array(0 to Kanaele-1);
--	begin
--		for kanal in ergebnis'range loop
--			ergebnis(kanal).Kanaele(0) := Bitvector(kanal*ADAT_DATENMENGE-1        downto kanal*ADAT_DATENMENGE-24        );
--			ergebnis(kanal).Kanaele(1) := Bitvector(kanal*ADAT_DATENMENGE-1 - 1*24 downto kanal*ADAT_DATENMENGE-24 - 1*24 );
--			ergebnis(kanal).Kanaele(2) := Bitvector(kanal*ADAT_DATENMENGE-1 - 2*24 downto kanal*ADAT_DATENMENGE-24 - 1*24 );
--			ergebnis(kanal).Kanaele(3) := Bitvector(kanal*ADAT_DATENMENGE-1 - 3*24 downto kanal*ADAT_DATENMENGE-24 - 1*24 );
--			ergebnis(kanal).Kanaele(4) := Bitvector(kanal*ADAT_DATENMENGE-1 - 4*24 downto kanal*ADAT_DATENMENGE-24 - 1*24 );
--			ergebnis(kanal).Kanaele(5) := Bitvector(kanal*ADAT_DATENMENGE-1 - 5*24 downto kanal*ADAT_DATENMENGE-24 - 1*24 );
--			ergebnis(kanal).Kanaele(6) := Bitvector(kanal*ADAT_DATENMENGE-1 - 6*24 downto kanal*ADAT_DATENMENGE-24 - 1*24 );
--			ergebnis(kanal).Kanaele(7) := Bitvector(kanal*ADAT_DATENMENGE-1 - 7*24 downto kanal*ADAT_DATENMENGE-24 - 1*24 );
--			ergebnis(kanal).UserBits := "1111"; --TODO .Ändern
--		end loop;
--		return ergebnis;
--	end function;
	
	
	
	
---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end ADAT;
