-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- tb_AdderSubtractor_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for an N-bit ripple carry
-- adder.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_AdderSubtractor_N is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_AdderSubtractor_N;

architecture mixed of tb_AdderSubtractor_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component AdderSubtractor_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A			: in std_logic_vector(N-1 downto 0);
	   i_B			: in std_logic_vector(N-1 downto 0);
	   i_nAdd_Sub	: in std_logic;
	   o_Sums		: out std_logic_vector(N-1 downto 0);
       o_Carry_Out  : out std_logic;
	   o_Overflow	: out std_logic;
	   o_Zero		: out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

constant N : integer := 32;

-- TODO: change input and output signals as needed.
signal s_A   		: std_logic_vector(N-1 downto 0) := x"00000000";
signal s_B   		: std_logic_vector(N-1 downto 0) := x"00000000";
signal s_nAdd_Sub   : std_logic := '0';
signal s_Sums    	: std_logic_vector(N-1 downto 0);
signal s_Carry_Out	: std_logic;
signal s_Overflow	: std_logic;
signal s_Zero		: std_logic;


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: AdderSubtractor_N
  port map(
	   i_A			=> s_A,
	   i_B 			=> s_B,
	   i_nAdd_Sub  	=> s_nAdd_Sub,
	   o_Sums  		=> s_Sums,
	   o_Carry_Out 	=> s_Carry_Out,
	   o_Overflow	=> s_Overflow,
	   o_Zero		=> s_Zero);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    s_A   		<= x"0000000A";  
    s_B   		<= x"00000007";
    s_nAdd_Sub	<= '1';
    wait for gCLK_HPER*2;
    -- Expect output to be 0x00000003, signed arithmetic (carry out can be ignored)

    -- Test case 2:
    s_A   		<= x"0000000A";  
    s_B   		<= x"00000007";
    s_nAdd_Sub	<= '0';
    wait for gCLK_HPER*2;
    -- Expect output to be 0x00000011, unsigned arithmetic (carry out important, overflow ignored)

    -- Test case 3:
    s_A   		<= x"00A0000A";  
    s_B   		<= x"00000007";
    s_nAdd_Sub	<= '1';
    wait for gCLK_HPER*2;
    -- Expect output to be 0x00A00003

    -- Test case 4:
    s_A   		<= x"00A0000A";  
    s_B   		<= x"00000007";
    s_nAdd_Sub	<= '0';
    wait for gCLK_HPER*2;
    -- Expect output to be 0x00A00011

    -- Test case 5:
    s_A   		<= x"FFFFFFFF";  
    s_B   		<= x"00000000";
    s_nAdd_Sub	<= '0';
    wait for gCLK_HPER*2;
    -- Expect output to be 0xFFFFFFFF

    -- Test case 6:
    s_A   		<= x"FFFFFFFF";  
    s_B   		<= x"00000000";
    s_nAdd_Sub	<= '1';
    wait for gCLK_HPER*2;
    -- Expect output to be 0xFFFFFFFF

  end process;

end mixed;