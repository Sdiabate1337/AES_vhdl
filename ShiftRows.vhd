library ieee;
use ieee.std_logic_1164.all;

entity ShiftRows is
    port (
        input : in std_logic_vector(127 downto 0);
        output : out std_logic_vector(127 downto 0)
    );
end ShiftRows;

architecture Behavioral of ShiftRows is
begin
    -- Perform ShiftRows operation
    process(input)
    begin
        output(7 downto 0)     <= input(7 downto 0);   -- Row 0 (no shift)
        output(15 downto 8)    <= input(151 downto 144); -- Row 1 (left shift by 1 byte)
        output(23 downto 16)   <= input(23 downto 16);  -- Row 2 (no shift)
        output(31 downto 24)   <= input(119 downto 112); -- Row 3 (left shift by 3 bytes)
        output(39 downto 32)   <= input(39 downto 32);  -- Row 4 (no shift)
        output(47 downto 40)   <= input(87 downto 80);  -- Row 5 (left shift by 2 bytes)
        output(55 downto 48)   <= input(55 downto 48);  -- Row 6 (no shift)
        output(63 downto 56)   <= input(183 downto 176); -- Row 7 (left shift by 1 byte)
        output(71 downto 64)   <= input(71 downto 64);  -- Row 8 (no shift)
        output(79 downto 72)   <= input(135 downto 128); -- Row 9 (left shift by 3 bytes)
        output(87 downto 80)   <= input(87 downto 80);  -- Row 10 (no shift)
        output(95 downto 88)   <= input(23 downto 16);  -- Row 11 (left shift by 2 bytes)
        output(103 downto 96)  <= input(103 downto 96); -- Row 12 (no shift)
        output(111 downto 104) <= input(167 downto 160); -- Row 13 (left shift by 1 byte)
        output(119 downto 112) <= input(119 downto 112); -- Row 14 (no shift)
        output(127 downto 120) <= input(151 downto 144); -- Row 15 (left shift by 1 byte)
    end process;

end Behavioral;
