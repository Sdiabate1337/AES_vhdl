library ieee;
use ieee.std_logic_1164.all;

entity AES is
    port (
        clk : in std_logic;
        reset : in std_logic;
        plaintext : in std_logic_vector(127 downto 0);
        key : in std_logic_vector(127 downto 0);
        ciphertext : out std_logic_vector(127 downto 0)
    );
end AES;

architecture Behavioral of AES is
    -- Define internal signals and components
    signal roundKeys : std_logic_vector(127 downto 0);
    signal state : std_logic_vector(127 downto 0);
    signal nextState : std_logic_vector(127 downto 0);

    -- Key Expansion
    component KeyExpansion is
        port (
            clk : in std_logic;
            reset : in std_logic;
            key : in std_logic_vector(127 downto 0);
            roundKeys : out std_logic_vector(127 downto 0)
        );
    end component;

    -- SubBytes
    component SubBytes is
        port (
            input : in std_logic_vector(7 downto 0);
            output : out std_logic_vector(7 downto 0)
        );
    end component;

    -- ShiftRows
    component ShiftRows is
        port (
            input : in std_logic_vector(127 downto 0);
            output : out std_logic_vector(127 downto 0)
        );
    end component;

    -- MixColumns
    component MixColumns is
        port (
            input : in std_logic_vector(127 downto 0);
            output : out std_logic_vector(127 downto 0)
        );
    end component;

    -- AddRoundKey
    component AddRoundKey is
        port (
            state : in std_logic_vector(127 downto 0);
            roundKey : in std_logic_vector(127 downto 0);
            output : out std_logic_vector(127 downto 0)
        );
    end component;

begin
    -- Key Expansion
    key_expansion_inst : KeyExpansion
        port map (
            clk => clk,
            reset => reset,
            key => key,
            roundKeys => roundKeys
        );

    -- State initialization
    state <= plaintext;

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset state and other registers
                state <= (others => '0');
                -- Reset other signals and registers
            else
                -- AES encryption algorithm

                -- AddRoundKey
                AddRoundKey_inst : AddRoundKey
                    port map (
                        state => state,
                        roundKey => roundKeys(0),
                        output => nextState
                    );
                state <= nextState;

                -- Loop through AES rounds
                for round in 1 to 9 loop
                    -- SubBytes
                    SubBytes_inst : SubBytes
                        port map (
                            input => state(7 downto 0),
                            output => nextState(7 downto 0)
                        );
                    state <= nextState;

                    -- ShiftRows
                    ShiftRows_inst : ShiftRows
                        port map (
                            input => state,
                            output => nextState
                        );
                    state <= nextState;

                    -- MixColumns
                    MixColumns_inst : MixColumns
                        port map (
                            input => state,
                            output => nextState
                        );
                    state <= nextState;

                    -- AddRoundKey
                    AddRoundKey_inst : AddRoundKey
                        port map (
                            state => state,
                            roundKey => roundKeys(round),
                            output => nextState
                        );
                    state <= nextState;
                    ciphertext <= state;
            end if;
        end if;
    end process;
end Behavioral;

