library ieee;
use ieee.std_logic_1164.all;

entity MixColumns is
    port (
        input : in std_logic_vector(127 downto 0);
        output : out std_logic_vector(127 downto 0)
    );
end MixColumns;

architecture Behavioral of MixColumns is
    -- AES MixColumns matrix
    constant mixMatrix : std_logic_vector(127 downto 0) :=
        x"02" & x"03" & x"01" & x"01" &
        x"01" & x"02" & x"03" & x"01" &
        x"01" & x"01" & x"02" & x"03" &
        x"03" & x"01" & x"01" & x"02";

    -- Multiply operation for GF(2^8)
    function multiply(a, b : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(7 downto 0);
    begin
        variable aVar, bVar : integer;
    begin
        aVar := to_integer(unsigned(a));
        bVar := to_integer(unsigned(b));

        case aVar is
            when 1 =>
                result := b;
            when 2 =>
                result := "0" & b(6 downto 0) xor '1';
            when 3 =>
                result := b(7) & b(6 downto 0) xor b;
            when others =>
                result := (others => '0');
        end case;

        return result;
    end multiply;

begin
    -- Perform MixColumns operation
    process(input)
        variable column : std_logic_vector(31 downto 0);
    begin
        for i in 0 to 3 loop
            -- Extract a column from the input state matrix
            column := input(i*32+31 downto i*32);

            -- Perform the matrix multiplication
            output(i*32+31 downto i*32) :=
                multiply(mixMatrix(i*32+31 downto i*32), column) xor
                multiply(mixMatrix(i*32+23 downto i*32+16), column(31 downto 24)) xor
                multiply(mixMatrix(i*32+15 downto i*32+8), column(23 downto 16)) xor
                multiply(mixMatrix(i*32+7 downto i*32), column(15 downto 8));
        end loop;
    end process;

end Behavioral;
