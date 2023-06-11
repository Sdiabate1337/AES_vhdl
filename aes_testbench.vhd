library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AES_Test is
end entity AES_Test;

architecture Behavioral of AES_Test is
    signal clk : std_logic := '0';
    signal plaintext : std_logic_vector(127 downto 0) := x"00112233445566778899AABBCCDDEEFF";
    signal key : std_logic_vector(127 downto 0) := x"000102030405060708090A0B0C0D0E0F";
    signal ciphertext : std_logic_vector(127 downto 0);

    component AES is
        generic (
            ROUNDS : integer := 10
        );
        port (
            clk        : in std_logic;
            plaintext  : in std_logic_vector(127 downto 0);
            key        : in std_logic_vector(127 downto 0);
            ciphertext : out std_logic_vector(127 downto 0)
        );
    end component AES;

begin
    -- Instanciation de l'entité AES
    aes_inst : AES
        generic map (
            ROUNDS => 10
        )
        port map (
            clk        => clk,
            plaintext  => plaintext,
            key        => key,
            ciphertext => ciphertext
        );

    -- Processus de simulation pour générer une horloge
    simulate_clk : process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process simulate_clk;

    -- Affichage du résultat du chiffrement
    process
    begin
        wait for 100 ns;  -- Attendre la fin du chiffrement
        report "Cipher Text: " & to_string(ciphertext);
        wait;
    end process;
end architecture Behavioral;
