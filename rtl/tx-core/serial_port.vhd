-- ####################################
-- # Project: Yarr
-- # Author: Timon Heim
-- # E-Mail: timon.heim at cern.ch
-- # Comments: Serial Port
-- # Outputs are synchronous to clk_i
-- ####################################

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.board_pkg.all;

entity serial_port is
	generic (
        g_PORT_WIDTH : integer := 32
    );
    port (
        -- Sys connect
        clk_i       : in std_logic;
        rst_n_i     : in std_logic;
        -- Input
        enable_i    : in std_logic;
        data_i      : in std_logic_vector(g_PORT_WIDTH-1 downto 0);
        idle_i      : in std_logic_vector(g_PORT_WIDTH-1 downto 0);
        sync_i      : in std_logic_vector(g_PORT_WIDTH-1 downto 0);
        sync_interval_i : in std_logic_vector(7 downto 0);
        az_i      : in std_logic_vector(g_PORT_WIDTH-1 downto 0);
        az_interval_i : in std_logic_vector(15 downto 0);
        
        data_valid_i : in std_logic;
        -- Output
        data_o      : out std_logic;
        data_read_o   : out std_logic
    );
end serial_port;

architecture behavioral of serial_port is
	function log2_ceil(N : natural) return positive is
	begin
		if N <= 2 then
		  return 1;
		elsif N mod 2 = 0 then
		  return 1 + log2_ceil(N/2);
		else
		  return 1 + log2_ceil((N+1)/2);
		end if;
	end;
    -- Signals
    constant c_ZEROS : std_logic_vector(g_PORT_WIDTH-1 downto 0) := (others => '0');
    signal bit_count : unsigned(log2_ceil(g_PORT_WIDTH) downto 0);
    signal sreg      : std_logic_vector(g_PORT_WIDTH-1 downto 0);
    signal sync_cnt : unsigned(7 downto 0);
    signal az_cnt : unsigned(15 downto 0);
    signal bx_tick : std_logic;
begin

    -- Serializer proc
    serialize: process(clk_i, rst_n_i)
    begin
		if (rst_n_i = '0') then
			sreg <= (others => '0');
			bit_count <= (others => '0');
			data_read_o <= '0';
			sync_cnt <= (others => '0');
			az_cnt <= (others => '0');
            data_o <= '0';
		elsif rising_edge(clk_i) then
            -- Output register
            data_o <= sreg(g_PORT_WIDTH-1);
            -- Priority encoder
            -- 1. Input via data_i port (fifo/looper) [only when enabled]
            -- 3. Autozero word [only when enabled]
            -- 2. Sync word
            -- 4. Idle
            if (bit_count = g_PORT_WIDTH-1 and data_valid_i = '1' and enable_i = '1') then
                sreg <= data_i;
                data_read_o <= '1';
                bit_count <= (others => '0');
                sync_cnt <= sync_cnt + 1;
                az_cnt <= az_cnt + 1;
            elsif (bit_count = g_PORT_WIDTH-1 and az_cnt >= unsigned(az_interval_i) and (az_i /= c_ZEROS) and (enable_i = '1')) then --
                sreg <= az_i;
                bit_count <= (others => '0');
                sync_cnt <= sync_cnt + 1;				        
                az_cnt <= (others => '0');
            elsif (bit_count = g_PORT_WIDTH-1 and sync_cnt >= unsigned(sync_interval_i) and (sync_i /= c_ZEROS)) then
                sreg <= sync_i;
                bit_count <= (others => '0');
                sync_cnt <= (others => '0');
                az_cnt <= az_cnt + 1;
            --elsif (bit_count = g_PORT_WIDTH-1 and data_valid_i = '0') then
            elsif (bit_count = g_PORT_WIDTH-1) then
                sreg <= idle_i;
                bit_count <= (others => '0');
                sync_cnt <= sync_cnt + 1;
                az_cnt <= az_cnt + 1;
            else
                sreg <= sreg(g_PORT_WIDTH-2 downto 0) & '0';
                data_read_o <= '0';
                bit_count <= bit_count + 1;
            end if;

            bx_tick <= '0';
            if (bit_count mod c_TX_40_DIVIDER = 0) then
                bx_tick <= '1';
            end if;
		end if;
    end process serialize;
end behavioral;
