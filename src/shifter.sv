
`define s1 2'b00
`define s2 2'b01
`define s3 2'b10
`define s4 2'b11

module shifter(in,shift,sout);
input [15:0] in;
input [1:0] shift;
output [15:0] sout;

reg  [15:0] sout;

always @(*) begin 

case (shift)

`s1: sout =in ;
`s2: 
      begin
     sout= in <<1 ;
     sout[0] =1'b0;
      end

`s3:  begin
     sout= in>>1 ;
     sout[15] =1'b0;
      end

`s4:  begin
     sout= in >>1 ;
     sout[15] = in[15];
      end

endcase

end 


endmodule
