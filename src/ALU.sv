
`define  s_sum 2'b00
`define  s_sub 2'b01
`define  s_and 2'b10
`define  s_not 2'b11

module ALU(Ain,Bin,ALUop,out,Z,N,V);
input [15:0] Ain, Bin;
input [1:0] ALUop;
output [15:0] out;
output N,V;
output  Z;

reg N,V;

reg [15:0] out;

reg  Z;


always @(*) begin 


case (ALUop)
`s_sum : out = Ain + Bin ;  // output computation
`s_sub : out =Ain - Bin ;
`s_and : out =Ain & Bin ;
`s_not : out = ~Bin ;
default :  ;
// not sure how to use default here do we even need it ?
endcase

case (ALUop)  // overflow happens when we have the same sign for AIn and BIn but out has the differnet singn so basically they exceed the bit limit
`s_sum : V=(Ain[15]==Bin[15] && out[15]!= Ain[15]) ;
// for subtraction Overflow happens when AIn and BIn have diff signs and result sign is not same as the Ain which is the subtracrtor
`s_sub : V=(Ain[15]!=Bin[15] && out[15]!= Ain[15]) ;
`s_and : V=1'b0;
`s_not : V=1'b0;
default: ;

endcase

if (out == 16'b0000_0000_0000_0000)
     Z=1'b1; 
     
else  
     Z=1'b0;
      

if (out[15]==1'b1)

            N=1'b1;  // if MSB is 1 negative flag is 1 
else 
            N=1'b0;



end  //aoutlways

endmodule



