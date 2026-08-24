
`define sw 2
`define s_sum  2'b00
`define  s_sub 2'b01
`define  s_and 2'b10
`define  s_not 2'b11

module ALU_tb;
reg [15:0] Ain_tb, Bin_tb;
reg [1:0] ALUop_tb;
wire [15:0] out_tb;
wire Z_tb; 
reg  err  ;



initial #500 $finish;

ALU DUT (.Ain(Ain_tb),.Bin(Bin_tb),.ALUop(ALUop_tb),.out(out_tb),.Z(Z_tb));
 
	task my_checker;
	 
        input [15:0] out_expected;
        input Z_expected;
	begin
	   
	if(out_tb != out_expected) begin
        $display ("Wrong got %b , expected %b",out_tb,out_expected);
         err=1'b1 ;
	 
	end

        if(Z_tb != Z_expected) begin
        $display ("Wrong got %b , expected %b",Z_tb,Z_expected);
         err=1'b1;
	 
	end
	end
	endtask



initial begin 

err=1'b0 ;


//sum
Ain_tb=16'd10;
Bin_tb=16'd6 ; 
ALUop_tb=`s_sum ; #10;
my_checker(16'd16,1'b0);


Ain_tb=16'd1;
Bin_tb=16'd2 ;  
ALUop_tb=`s_sum ; #10;
my_checker(16'd3,1'b0);

//sub 



Ain_tb=16'b0000_0000_0000_0011;
Bin_tb=16'b0000_0000_0000_0011;
ALUop_tb=`s_sub ; #10;
my_checker(16'b0000_0000_0000_0000,1'b1);


Ain_tb=16'd5;
Bin_tb=16'd2 ;
ALUop_tb=`s_sub ;
#10;
my_checker(16'd3,1'b0);

//s_and

Ain_tb=16'b0000_0000_0000_0011;
Bin_tb=16'b0000_0000_0000_0011;
ALUop_tb=`s_and ; #10;
my_checker(16'b0000_0000_0000_0011,1'b0);


Ain_tb=16'b0110_0110_0110_0110;
Bin_tb=16'b0100_0100_0100_0100;
ALUop_tb=`s_and ;
#10;
my_checker(16'b0100_0100_0100_0100,1'b0);

//s_not

Ain_tb=16'b0000_0000_0000_0011; // doesnt matter here for ~Bin
Bin_tb= 16'b1111_1111_1111_1111 ;
ALUop_tb=`s_not ; #10;
my_checker(16'b0000_0000_0000_0000,1'b1);


Ain_tb=16'b0110_0110_0110_0110;  
Bin_tb=16'b1111_0100_0111_1111;
ALUop_tb=`s_not ;
#10;
my_checker(16'b0000_1011_1000_0000,1'b0);
//
Ain_tb=16'b0000_0000_0000_1111;
Bin_tb=16'b0000_0000_0000_0011;
ALUop_tb=`s_not ; #10;
my_checker(16'b1111_1111_1111_1100,1'b0);


Ain_tb=16'b0110_0110_0110_0110;
Bin_tb=16'b0100_0100_0100_0100;
ALUop_tb=`s_not ;
#10;
my_checker(16'b1011_1011_1011_1011,1'b0);

//s_not



end

endmodule : ALU_tb



