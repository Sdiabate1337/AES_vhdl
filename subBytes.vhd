library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes is
    generic (
        SBOX : std_logic_vector(255 downto 0)
    );
    port (
        clk   : in std_logic;
        input : in std_logic_vector(7 downto 0);
        output : out std_logic_vector(7 downto 0)
    );
end entity SubBytes;

architecture Behavioral of SubBytes is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            output <= SBOX(to_integer(unsigned(input)));
        end if;
    end process;
end architecture Behavioral;
