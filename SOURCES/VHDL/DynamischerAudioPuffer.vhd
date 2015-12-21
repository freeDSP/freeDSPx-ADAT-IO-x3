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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DynamischerADATPuffer is
	 Port ( -- Eingang --
			  In_NeueDaten		 : in bit;
	 
			  In_UserBits      : in bit_vector(3 downto 0);
           In_Audio_Kanal_0 : in bit_vector(23 downto 0);
           In_Audio_Kanal_1 : in bit_vector(23 downto 0);
           In_Audio_Kanal_2 : in bit_vector(23 downto 0);
           In_Audio_Kanal_3 : in bit_vector(23 downto 0);
           In_Audio_Kanal_4 : in bit_vector(23 downto 0);
           In_Audio_Kanal_5 : in bit_vector(23 downto 0);
           In_Audio_Kanal_6 : in bit_vector(23 downto 0);
           In_Audio_Kanal_7 : in bit_vector(23 downto 0);
			  
			  -- Ausgang --
			  PufferVoll : out bit := '0';
			  PufferLeer : out bit := '0';
			  
			  Out_DatenVerarbeitet : in bit; --Wechselt, wenn der nächste Frame an den Ausgang gelegt werden soll
			  
			  Out_UserBits      : out bit_vector(3 downto 0);
           Out_Audio_Kanal_0 : out bit_vector(23 downto 0);
           Out_Audio_Kanal_1 : out bit_vector(23 downto 0);
           Out_Audio_Kanal_2 : out bit_vector(23 downto 0);
           Out_Audio_Kanal_3 : out bit_vector(23 downto 0);
           Out_Audio_Kanal_4 : out bit_vector(23 downto 0);
           Out_Audio_Kanal_5 : out bit_vector(23 downto 0);
           Out_Audio_Kanal_6 : out bit_vector(23 downto 0);
           Out_Audio_Kanal_7 : out bit_vector(23 downto 0)
			  );
			  
end DynamischerADATPuffer;

architecture Behavioral of DynamischerADATPuffer is

begin


end Behavioral;

