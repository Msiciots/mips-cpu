// Mux2to1

module Mux2to1 ( I0,
				 I1,
				 S,
				 out);

	parameter bit_size = 16;

	input  [bit_size-1:0] I0;
	input  [bit_size-1:0] I1;
	input  S;

	output [bit_size-1:0] out;
  
	/* implement Mux2to1 */
	/* if( S==0 )
            assign out = I0 ;
        else
            assign out = I1 ;*/
	 assign out = (S==0)?I0:I1 ;

endmodule