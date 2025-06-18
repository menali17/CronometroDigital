library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cronometro is
    Port (
        CLK    : in  STD_LOGIC;
        RESET  : in  STD_LOGIC;
        START_STOP : in STD_LOGIC;
        DISP_SEG : out STD_LOGIC_VECTOR(7 downto 0); -- segmentos com lógica invertida (a-g + DP)
        DISP_SEL : out STD_LOGIC_VECTOR(2 downto 0)  -- seleção dos anodos (3 displays)
    );
end cronometro;

architecture Behavioral of cronometro is

    signal clk_div : unsigned(25 downto 0) := (others => '0');
    signal one_hz  : STD_LOGIC := '0';

    signal running : STD_LOGIC := '0';
    signal seconds : integer range 0 to 59 := 0;
    signal minutes : integer range 0 to 9 := 0;

    signal mux_count : unsigned(15 downto 0) := (others => '0');
    signal mux_sel   : integer range 0 to 2 := 0;

    signal digit_val : std_logic_vector(3 downto 0);
    signal seg_out   : std_logic_vector(7 downto 0);

    -- Botão debouncing simples
    signal btn_last : STD_LOGIC := '1';

begin

    -- Divisor de clock para gerar 1Hz (aproximado)
    process(CLK)
    begin
        if rising_edge(CLK) then
            clk_div <= clk_div + 1;
            if clk_div = 25_000_000 then
                one_hz <= '1';
                clk_div <= (others => '0');
            else
                one_hz <= '0';
            end if;
        end if;
    end process;

    -- Controle de Start/Stop por borda de descida
    process(CLK)
    begin
        if rising_edge(CLK) then
            if START_STOP = '0' and btn_last = '1' then
                running <= not running;
            end if;
            btn_last <= START_STOP;

            if RESET = '0' then
                seconds <= 0;
                minutes <= 0;
                running <= '0';
            elsif one_hz = '1' and running = '1' then
                seconds <= seconds + 1;
                if seconds = 60 then
                    seconds <= 0;
                    minutes <= minutes + 1;
                    if minutes = 10 then
                        minutes <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Multiplexação dos displays
    process(CLK)
    begin
        if rising_edge(CLK) then
            mux_count <= mux_count + 1;
            if mux_count = 50_000 then
                mux_count <= (others => '0');
                mux_sel <= (mux_sel + 1) mod 3;
            end if;
        end if;
    end process;

    -- Seleção dos dígitos
    process(mux_sel, minutes, seconds)
    begin
        case mux_sel is
            when 0 => digit_val <= std_logic_vector(to_unsigned(seconds mod 10, 4));  -- Unidade dos segundos
            when 1 => digit_val <= std_logic_vector(to_unsigned(seconds / 10, 4));    -- Dezena dos segundos
            when 2 => digit_val <= std_logic_vector(to_unsigned(minutes, 4));         -- Minutos
            when others => digit_val <= "0000";
        end case;
    end process;

    -- Decodificador BCD para 7 segmentos com lógica invertida
    process(digit_val)
    begin
        case digit_val is
            when "0000" => seg_out <= "11000000"; -- 0
            when "0001" => seg_out <= "11111001"; -- 1
            when "0010" => seg_out <= "10100100"; -- 2
            when "0011" => seg_out <= "10110000"; -- 3
            when "0100" => seg_out <= "10011001"; -- 4
            when "0101" => seg_out <= "10010010"; -- 5
            when "0110" => seg_out <= "10000010"; -- 6
            when "0111" => seg_out <= "11111000"; -- 7
            when "1000" => seg_out <= "10000000"; -- 8
            when "1001" => seg_out <= "10010000"; -- 9
            when others => seg_out <= "11111111"; -- Apagar tudo
        end case;
    end process;

    -- Saídas de segmentos
    DISP_SEG <= seg_out;

    -- Controle de anodos (3 displays: unidade, dezena, minuto) - lógica ativa baixa
    process(mux_sel)
    begin
        case mux_sel is
            when 0 => DISP_SEL <= "110";  -- Habilita 1º display
            when 1 => DISP_SEL <= "101";  -- Habilita 2º display
            when 2 => DISP_SEL <= "011";  -- Habilita 3º display
            when others => DISP_SEL <= "111"; -- Nenhum ativo
        end case;
    end process;

end Behavioral;
