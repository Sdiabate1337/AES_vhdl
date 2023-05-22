library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AES is
    generic (
        ROUNDS : integer := 10
    );
    port (
        clk        : in std_logic;
        plaintext  : in std_logic_vector(127 downto 0);
        key        : in std_logic_vector(127 downto 0);
        ciphertext : out std_logic_vector(127 downto 0)
    );
end entity AES;

architecture Behavioral of AES is
    constant SBOX : std_logic_vector(255 downto 0) := (
        x"63", x"7C", x"77", x"7B", x"F2", x"6B", x"6F", x"C5",
        x"30", x"01", x"67", x"2B", x"FE", x"D7", x"AB", x"76",
        x"CA", x"82", x"C9", x"7D", x"FA", x"59", x"47", x"F0",
        x"AD", x"D4", x"A2", x"AF", x"9C", x"A4", x"72", x"C0",
        x"B7", x"FD", x"93", x"26", x"36", x"3F", x"F7", x"CC",
        x"34", x"A5", x"E5", x"F1", x"71", x"D8", x"31", x"15",
        x"04", x"C7", x"23", x"C3", x"18", x"96", x"05", x"9A",
        x"07", x"12", x"80", x"E2", x"EB", x"27", x"B2", x"75",
        x"09", x"83", x"2C", x"1A", x"1B", x"6E", x"5A", x"A0",
        x"52", x"3B", x"D6", x"B3", x"29", x"E3", x"2F", x"84",
        x"53", x"D1", x"00", x"ED", x"20", x"FC", x"B1", x"5B",
        x"6A", x"CB", x"BE", x"39", x"4A", x"4C", x"58", x"CF",
        x"D0", x"EF", x"AA", x"FB", x"43", x"4D", x"33", x"85",
        x"45", x"F9", x"02", x"7F", x"50", x"3C", x"9F", x"A8",
        x"51", x"A3", x"40", x"8F", x"92", x"9D", x"38", x"F5",
        x"BC", x"B6", x"DA", x"21", x"10", x"FF", x"F3", x"D2",
        x"CD", x"0C", x"13", x"EC", x"5F", x"97", x"44", x"17",
        x"C4", x"A7", x"7E", x"3D", x"64", x"5D", x"19", x"73",
        x"60", x"81", x"4F", x"DC", x"22", x"2A", x"90", x"88",
        x"46", x"EE", x"B8", x"14", x"DE", x"5E", x"0B", x"DB",
        x"E0", x"32", x"3A", x"0A", x"49", x"06", x"24", x"5C",
        x"C2", x"D3", x"AC", x"62", x"91", x"95", x"E4", x"79",
        x"E7", x"C8", x"37", x"6D", x"8D", x"D5", x"4E", x"A9",
        x"6C", x"56", x"F4", x"EA", x"65", x"7A", x"AE", x"08",
        x"BA", x"78", x"25", x"2E", x"1C", x"A6", x"B4", x"C6",
        x"E8", x"DD", x"74", x"1F", x"4B", x"BD", x"8B", x"8A",
        x"70", x"3E", x"B5", x"66", x"48", x"03", x"F6", x"0E",
        x"61", x"35", x"57", x"B9", x"86", x"C1", x"1D", x"9E",
        x"E1", x"F8", x"98", x"11", x"69", x"D9", x"8E", x"94",
        x"9B", x"1E", x"87", x"E9", x"CE", x"55", x"28", x"DF",
        x"8C", x"A1", x"89", x"0D", x"BF", x"E6", x"42", x"68",
        x"41", x"99", x"2D", x"0F", x"B0", x"54", x"BB", x"16"
    );

    signal state : std_logic_vector(127 downto 0);

    component SubBytes is
        generic (
            SBOX : std_logic_vector(255 downto 0)
        );
        port (
            clk    : in std_logic;
            input  : in std_logic_vector(7 downto 0);
            output : out std_logic_vector(7 downto 0)
        );
    end component SubBytes;

    component ShiftRows is
        port (
            clk    : in std_logic;
            input  : in std_logic_vector(127 downto 0);
            output : out std_logic_vector(127 downto 0)
        );
    end component ShiftRows;

    component MixColumns is
        port (
            clk    : in std_logic;
            input  : in std_logic_vector(127 downto 0);
            output : out std_logic_vector(127 downto 0)
        );
    end component MixColumns;

    component AddRoundKey is
        port (
            clk       : in std_logic;
            input     : in std_logic_vector(127 downto 0);
            round_key : in std_logic_vector(127 downto 0);
            output    : out std_logic_vector(127 downto 0)
        );
    end component AddRoundKey;

    function RotWord(input : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return input(7 downto 0) & input(31 downto 8);
    end function RotWord;

    function SubWord(input : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return SBOX(to_integer(unsigned(input(7 downto 4)))) &
               SBOX(to_integer(unsigned(input(3 downto 0)))) &
               SBOX(to_integer(unsigned(input(15 downto 12)))) &
               SBOX(to_integer(unsigned(input(11 downto 8))));
    end function SubWord;

    function KeyExpansion(round_key : std_logic_vector(127 downto 0); round : integer) return std_logic_vector(127 downto 0) is
        variable temp : std_logic_vector(31 downto 0);
    begin
        temp := RotWord(round_key(31 downto 0));
        temp := SubWord(temp);
        temp := temp xor x"01" & x"00" & x"00" & x"00";

        return round_key(127 downto 32) & temp;
    end function KeyExpansion;

begin
    process(clk)
        variable round_key : std_logic_vector(127 downto 0);
        variable round : integer;
    begin
        if rising_edge(clk) then
            if round = 0 then
                state <= plaintext;
                round_key := key;
                round := 0;
            else
                state <= AddRoundKey_inst.output;
                round_key := KeyExpansion(round_key, round);
                round := round + 1;
            end if;

            if round < ROUNDS then
                for i in 1 to 9 loop
                    SubBytes_inst : SubBytes
                        generic map (
                            SBOX => SBOX
                        )
                        port map (
                            clk    => clk,
                            input  => state(7 downto 0),
                            output => state(7 downto 0)
                        );
                    ShiftRows_inst : ShiftRows
                        port map (
                            clk    => clk,
                            input  => state,
                            output => state
                        );
                    MixColumns_inst : MixColumns
                        port map (
                            clk    => clk,
                            input  => state,
                            output => state
                        );
                    AddRoundKey_inst : AddRoundKey
                        port map (
                            clk       => clk,
                            input     => state,
                            round_key => round_key,
                            output    => state
                        );
                end loop;

                SubBytes_inst : SubBytes
                    generic map (
                        SBOX => SBOX
                    )
                    port map (
                        clk    => clk,
                        input  => state(7 downto 0),
                        output => state(7 downto 0)
                    );
                ShiftRows_inst : ShiftRows
                    port map (
                        clk    => clk,
                        input  => state,
                        output => state
                    );
                AddRoundKey_inst : AddRoundKey
                    port map (
                        clk       => clk,
                        input     => state,
                        round_key => round_key,
                        output    => state
                    );
                ciphertext <= state;
            end if;
        end if;
    end process;
end architecture Behavioral;
