library ieee;
use ieee.std_logic_1164.all;

entity ShiftRows is
    port (
        clk    : in std_logic;
        input  : in std_logic_vector(127 downto 0);
        output : out std_logic_vector(127 downto 0)
    );
end entity ShiftRows;

architecture Behavioral of ShiftRows is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Lorsque le front montant de l'horloge se produit,
            -- les octets d'entrée sont réarrangés selon la spécification de ShiftRows
            -- et les résultats sont affectés aux octets de sortie correspondants.
            output(7 downto 0)     <= input(7 downto 0);
            output(15 downto 8)    <= input(151 downto 144);
            output(23 downto 16)   <= input(23 downto 16);
            output(31 downto 24)   <= input(119 downto 112);
            output(39 downto 32)   <= input(39 downto 32);
            output(47 downto 40)   <= input(87 downto 80);
            output(55 downto 48)   <= input(55 downto 48);
            output(63 downto 56)   <= input(183 downto 176);
            output(71 downto 64)   <= input(71 downto 64);
            output(79 downto 72)   <= input(135 downto 128);
            output(87 downto 80)   <= input(87 downto 80);
            output(95 downto 88)   <= input(23 downto 16);
            output(103 downto 96)  <= input(103 downto 96);
            output(111 downto 104) <= input(167 downto 160);
            output(119 downto 112) <= input(119 downto 112);
            output(127 downto 120) <= input(151 downto 144);
        end if;
    end process;
end architecture Behavioral;
