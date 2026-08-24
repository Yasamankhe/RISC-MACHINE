`define s0 2'b00
`define s1 2'b01
`define s2 2'b10
`define s3 2'b11


module datapath (clk,readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write,Z_out,sximm5,sximm8,PC,mdata,C);
input clk,loada,loadb,asel,bsel,loadc,loads,write;
input [1:0] vsel,shift,ALUop;
input [2:0] readnum,writenum;
input [7:0] PC;
input [15:0] sximm5,sximm8, mdata;

output reg [2:0] Z_out;
output reg [15:0] C;

reg [15:0] data_in,A,B,Ain,Bin,in;
wire  Z,N,V;
wire [15:0] data_out,sout,out;






//1                                         Register_File
regfile REGFILE (.data_in(data_in),.data_out(data_out),.write(write),.readnum(readnum),.writenum(writenum),.clk(clk));




//2                                         Arithmetic_Logic_Unit
ALU ALU (.Ain(Ain),.Bin(Bin),.ALUop(ALUop),.out(out),.Z(Z),.N(N),.V(V)); 


//8
shifter Shifter(.in(in),.shift(shift),.sout(sout));  // does uppercase matter for this one 


// 3,4,5                                    PipeLine_Registers


 
always @(posedge clk) begin

 // hold the data path signals
	if (loada)  begin
	A <= data_out;                       //got rif of blocking
     end

	if(loadb) begin
	in <= data_out;
     end
                     //should I actuall do this ??

	 if(loadc) begin
          C <= out;
     end
end

//6,7                                    Source_Operand_MUX          
// change inputs to the ALU
// set Ain to zero

always @(*) begin

Ain =(asel == 1) ? 16'b0 : A;


Bin =(bsel == 1) ? sximm5 : sout ;   // new modification

                                
end

//8
//shifter Shifter(.in(in),.shift(shift),.sout(sout));  // does uppercase matter for this one 

 

//9                                       WriteBack_MUX

//Alu has computed a value---result is saved in reg C--
// want to use this value as an input for next instructions OR input values from other sources



always @(*)begin
 //data_in =(vsel=1) ? datapath_in : datapath_out;
 case (vsel)
 `s0: data_in= C;
 `s1: data_in= {8'b0,PC};
 `s2: data_in= sximm8;              // new modification for lab 6
 `s3: data_in= mdata;

endcase 


end 


//10                                     Status_Register

// remember if the output of ALU calc has a special meaning resulting in its destination
// it should record Z from ALU if loads==1 and IF NOT keep the current out

always @(posedge clk) begin
         Z_out[0]= Z;
         Z_out[1]= N;
         Z_out[2]= V;
   
 end 


endmodule

