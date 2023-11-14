library IEEE;
use IEEE.std_logic_1164.all;

entity hazard_detection is
	port(jr, branch, jump, ID_EX_MemtoReg, EX_MEM_MemtoReg	
		: in std_logic;
	rd, rt, EX_MEM_mux
		: in std_logic_vector (4 downto 0);
	i_opcode, i_func		
		: in std_logic_vector(5 downto 0);
	ID_EX, EX_MEM
		: in std_logic_vector (31 downto 0);
	ID_EX_stall, ID_EX_flush, IF_ID_flush, IF_ID_stall, PC_stall, o_control_hazard
		: out std_logic);
end hazard_detection;

architecture dataflow of hazard_detection is
begin
-- '0' is stall, '1' is no stall
-- stall when jr or not writing to mem to register
	ID_EX_stall <= '0' when	(((jr = '1') or (ID_EX_MemtoReg = '1')) and ((EX_MEM_mux = rt) or (EX_MEM_mux = rd)) and (EX_MEM_mux /= "00000"))
				else '1';

	ID_EX_flush <= '0' when ((EX_MEM_MemtoReg = '1') and (ID_EX = EX_MEM))
				else '1';
-- '0' when j, branch, or jr
	IF_ID_flush <= '0' when ((jr = '1') or (branch = '1') or (jump = '1'))
				else '1';
-- '0' when writing to reg and the next input is = to the reg
	IF_ID_stall <= '0' when (((ID_EX_MemtoReg = '1') and ((EX_MEM_mux = rt) or (EX_MEM_mux = rd)) and (EX_MEM_mux /= "00000")) or (branch = '1') or (jump = '1') or (jr = '1'))
				else '1';

	PC_stall <= '0' when (((ID_EX_MemtoReg = '1') and ((EX_MEM_mux = rt) or (EX_MEM_mux = rd)) and (EX_MEM_mux /= "00000")) or (jump = '1') or (branch = '1') or (jr = '1'))
				else '1';
-- if writing to the reg and using the value or branch, jump, or jr

	o_control_hazard <= '1' when ((i_opcode = "000100") or (i_opcode = "000101"))	
				else '0';

end dataflow;
