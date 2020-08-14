// Forwarding Unit

module FU ( // input 
			EX_Rs,
            EX_Rt,
			M_RegWrite,
			M_WR_out,
			WB_RegWrite,
			WB_WR_out,
			// output
			enF1,
			enF2,
			sF1,
			sF2	
			);

	input [4:0] EX_Rs;
    input [4:0] EX_Rt;
    input M_RegWrite;
    input [4:0] M_WR_out;
    input WB_RegWrite;
    input [4:0] WB_WR_out;

	output enF1;
    output enF2;
    output sF1;
    output sF2;
	
	reg enF1;
	reg enF2;
	reg sF1;
	reg sF2;

	always @(*) begin
		
		if(M_RegWrite && M_WR_out != 0 && M_WR_out == EX_Rs)
		begin
			enF1 = 1;	
			sF1  = 0;	//0 = M
		end
		else if(WB_RegWrite && WB_WR_out != 0 && WB_WR_out == EX_Rs)
		begin
			enF1 = 1;	
			sF1  = 1;	//1 = WB
		end
		else
		begin
			enF1 = 0;	//no forwarding
			sF1  = 0;
		end
		
		/* ----------------------- */
		
		
		if(M_RegWrite && M_WR_out != 0 && M_WR_out == EX_Rt)
		begin
			enF2 = 1;	
			sF2  = 0;	//0 = M
		end
		else if(WB_RegWrite && WB_WR_out != 0 && WB_WR_out == EX_Rt)
		begin
			enF2 = 1;	
			sF2  = 1;	//1 = WB
		end
		else
		begin
			enF2 = 0;	//forwardB = 00, no forwarding
			sF2  = 0;
		end

	end
	
endmodule