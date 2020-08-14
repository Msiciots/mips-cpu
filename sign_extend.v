// sign_extend

module sign_extend ( in,
					 out);
					 
	input  [15:0] in;
	output [31:0] out;
	/* implement sign_extend */
  
	// assign out = ;
	
    
  assign out = { {16{in[15]}},in };
endmodule	