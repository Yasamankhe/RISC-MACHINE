
`define s1 2'b00
`define s2 2'b01
`define s3 2'b10
`define s4 2'b11

module shifter_tb();
reg [15:0] in_tb;
reg [1:0] shift_tb;
wire [15:0] sout_tb;
reg err;

initial #500 $finish;
shifter DUT (.in(in_tb),.shift(shift_tb),.sout(sout_tb));


task my_checker;
	 
        input [15:0] out_expected;
       
	begin
	   
	if(sout_tb != out_expected) begin
        $display ("Wrong got %b , expected %b",sout_tb,out_expected);
         err=1'b1 ;
	 
	end
	end
	endtask



initial begin 

err=1'b0 ;


//s1= out=in
in_tb=16'd10;
shift_tb=`s1; #10;
my_checker(16'd10);

in_tb=16'd6550;
shift_tb=`s1; #10;
my_checker(16'd6550);

in_tb=16'd0;
shift_tb=`s1; #10;
my_checker(16'd0);

in_tb=16'd738;
shift_tb=`s1; #10;
my_checker(16'd738);

in_tb=16'd1001;
shift_tb=`s1; #10;
my_checker(16'd1001);

// s2= shift to left lsb =0
in_tb=16'b0000_0000_0000_0011;
shift_tb=`s2; #10;
my_checker(16'b0000_0000_0000_0110);

in_tb=16'b1100_1110_1000_0010;
shift_tb=`s2; #10;
my_checker(16'b1001_1101_0000_0100);

in_tb=16'b1010_1010_1010_1101;
shift_tb=`s2; #10;
my_checker(16'b0101_0101_0101_1010);


//
// s3= shift to right lsb =0
in_tb=16'b0000_0000_0000_0011;
shift_tb=`s3; #10;
my_checker(16'b0000_0000_0000_0001);

in_tb=16'b1100_1110_1000_0010;
shift_tb=`s3; #10;
my_checker(16'b0110_0111_0100_0001);

in_tb=16'b1010_1010_1010_1010;
shift_tb=`s3; #10;
my_checker(16'b0101_0101_0101_0101);

// s4= shift to right msb =in[15]
in_tb=16'b0000_0000_0000_0011;
shift_tb=`s4; #10;
my_checker(16'b0000_0000_0000_0001);

in_tb=16'b1100_1110_1000_0010;
shift_tb=`s4; #10;
my_checker(16'b1110_0111_0100_0001);

in_tb=16'b1010_1010_1010_1010;
shift_tb=`s4; #10;
my_checker(16'b1101_0101_0101_0101);

in_tb=16'b1111_0000_1100_1111;
shift_tb=`s4; #10;
my_checker(16'b1111_1000_0110_0111);


end

endmodule :shifter_tb