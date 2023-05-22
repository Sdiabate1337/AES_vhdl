library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MixColumns is
    port (
        clk    : in std_logic;
        input  : in std_logic_vector(127 downto 0);
        output : out std_logic_vector(127 downto 0)
    );
end entity MixColumns;

architecture Behavioral of MixColumns is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Perform MixColumns operation
            for i in 0 to 3 loop
                output(31 downto 0 + 32*i)   <= input(31 downto 0 + 32*i) xor (input(95 downto 64 + 32*i) and x"0000000000000000000000000000000e") xor (input(63 downto 32 + 32*i) and x"0000000000000000000000000000000b") xor (input(31 downto 0 + 32*i) and x"0000000000000000000000000000000d") xor (input(127 downto 96 + 32*i) and x"00000000000000000000000000000009");
                output(63 downto 32 + 32*i)   <= input(63 downto 32 + 32*i) xor (input(31 downto 0 + 32*i) and x"0000000000000000000000000000000e") xor (input(95 downto 64 + 32*i) and x"0000000000000000000000000000000b") xor (input(63 downto 32 + 32*i) and x"0000000000000000000000000000000d") xor (input(127 downto 96 + 32*i) and x"00000000000000000000000000000009");
                output(95 downto 64 + 32*i)   <= input(95 downto 64 + 32*i) xor (input(63 downto 32 + 32*i) and x"0000000000000000000000000000000e") xor (input(31 downto 0 + 32*i) and x"0000000000000000000000000000000b") xor (input(95 downto 64 + 32*i) and x"0000000000000000000000000000000d") xor (input(127 downto 96 + 32*i) and x"00000000000000000000000000000009");
                output(127 downto 96 + 32*i) <= input(127 downto 96 + 32*i) xor (input(95 downto 64 + 32*i) and x"0000000000000000000000000000000e") xor (input(63 downto 32 + 32*i) and x"0000000000000000000000000000000b") xor (input(31 downto 0 + 32*i) and x"0000000000000000000000000000000d") xor (input(127 downto 96 + 32*i) and x"00000000000000000000000000000009");
            end loop;
        end if;
    end process;
end architecture Behavioral;
