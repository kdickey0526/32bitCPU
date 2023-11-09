library IEEE;
use IEEE.std_logic_1164.all;

entity data_hazard is
	port(jr, branch, jump, ID_EX_MemtoReg, EX_MEM_MemtoReg	
		: in std_logic;
	rd, rt, EX_MEM_mux
		: in std_logic_vector (4 downto 0);
	ID_EX, EX_MEM
		: in std_logic_vector (31 downto 0);
	ID_EX_stall, ID_EX_flush, IF_ID_flush, IF_ID_stall, PC_stall
		: out std_logic);
end data_hazard;

architecture dataflow of data_hazard is
begin
-- '0' is stall, '1' is no stall
-- stall when jr or not writing to mem to register
	ID_EX_stall <= '0' when	(((jr = '1') or (ID_EX_MemtoReg = '1')) and ((EX_MEM_mux = rt) or (EX_MEM_mux = rd)) and (EX_MEM_mux /= "00000"))
				else '1';

	ID_EX_flush <= '0' when ((EX_MEM_MemtoReg = '1') and (ID_EX = EX_MEM))
				else '1';
-- '0' when j, branch, or jr
	IF_ID_flush <= '0' when (jr = '1' or branch = '1' or jump = '1')
				else '1';
-- '0' when writing to reg and the next input is = to the reg
	IF_ID_stall <= '0' when (((ID_EX_MemtoReg = '1') and ((EX_MEM_mux = rt) or (EX_MEM_mux = rd)) and (EX_MEM_mux /= "00000")) or (branch = '1') or (jump = '1') or (jr = '1'))
				else '1';

	PC_stall <= '0' when ((((ID_EX_MemtoReg = '1') or (jr = '1')) and ((EX_MEM_mux = rt) or (EX_MEM_mux = rd)) and (EX_MEM_mux /= "00000"))) --or on a branch, jump, or jr
				else '1';
-- something with the pc

	
end dataflow;