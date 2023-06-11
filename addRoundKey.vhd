library ieee;
use ieee.std_logic_1164.all;

entity AddRoundKey is
    port (
        clk       : in std_logic;
        input     : in std_logic_vector(127 downto 0);
        round_key : in std_logic_vector(127 downto 0);
        output    : out std_logic_vector(127 downto 0)
    );
end entity AddRoundKey;

architecture Behavioral of AddRoundKey is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            output <= input xor round_key;
        end if;
    end process;
end architecture Behavioral;

