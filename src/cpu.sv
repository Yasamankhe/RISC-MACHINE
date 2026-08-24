module cpu(clk, reset, s, load, in, out, N, V, Z, w);
    input clk, reset, s, load;
    input [15:0] in;
    output [15:0] out;
    output N, V, Z, w;

    reg [15:0] out;
    reg  w;
    reg N, V, Z;

    reg [15:0] instruction, sximm8, sximm5; 
    reg [1:0] op, vsel, shift;
    reg [2:0] opcode, readnum, writenum, nsel;
    reg asel, bsel, loada, loadb, loadc, loads, write;
    reg [7:0] pc;
    reg [15:0] mdata;

    wire [2:0] Rm, Rd, Rn;
    reg [2:0] Z_out;
    reg [3:0] state, next_state;

    wire [15:0] C;

    // Datapath instantiation
    datapath DP (
        .clk(clk),
        .readnum(readnum),
        .vsel(vsel),
        .loada(loada),
        .loadb(loadb),
        .shift(shift),
        .asel(asel),
        .bsel(bsel),
        .ALUop(op),
        .loadc(loadc),
        .loads(loads),
        .writenum(writenum),
        .write(write),
        .Z_out(Z_out),
        .sximm5(sximm5),
        .sximm8(sximm8),
        .PC(pc),
        .mdata(mdata),
        .C(C)
    );

     always @(*) begin
	
         Z=Z_out[0];
         N=Z_out[1];
         V= Z_out[2];
    end
   
        

    
    always @(*) begin
        out = C;
    end

    // Instruction Register
    always @(posedge clk ) begin
       if (load)
            instruction <= in;
    end

    // Instruction Decoder
    assign Rm = instruction[2:0];
    assign Rd = instruction[7:5];
    assign Rn = instruction[10:8];

    always @(*) begin  
        opcode = instruction[15:13];
        op = instruction[12:11];
        shift = instruction[4:3];
        sximm5 = (instruction[4] == 0) ? {11'b00000000000, instruction[4:0]} : {11'b11111111111, instruction[4:0]};
        sximm8 = (instruction[7] == 0) ? {8'b00000000, instruction[7:0]} : {8'b11111111, instruction[7:0]};

        case (nsel)
            3'b001: begin
                readnum = Rm;
                writenum = Rm;
            end
            3'b010: begin
                readnum = Rd;
                writenum = Rd;
            end
            3'b100: begin
                readnum = Rn;
                writenum = Rn;
            end
            default: begin
                readnum = Rn;
                writenum = Rn;
            end
        endcase
    end





`define Wait       4'b0000
`define Decode     4'b0001
`define GetB       4'b0011
`define ALUOp      4'b0100
`define WriteReg   4'b0101
`define WriteImm   4'b0110
`define UpdateFlags 4'b0111
`define Shift      4'b1000



always @(posedge clk) begin
    if (reset == 1)
        state = `Wait;
    else begin
        case (state)
    `Wait: begin
               

                if (s == 1) begin
                    w = 0; // Exiting Wait state
                    
                    casex ({opcode, op})
                        5'b110_00: state = `Decode;    // MOV Rd, Rm {,<sh_op>}
                        5'b110_10: state = `WriteImm; // MOV Rn, #<im8>
                        5'b101_00: state = `Decode;    // ADD Rd, Rn, Rm {,<sh_op>}
                        5'b101_01: state = `Decode;    // CMP Rn, Rm {,<sh_op>}
                        5'b101_10: state = `Decode;    // AND Rd, Rn, Rm {,<sh_op>}
                        5'b101_11: state = `Decode;    // MVN Rd, Rm {,<sh_op>}
                        default: state = `Wait;         // Remain in Wait state
                    endcase
                end
    end     

`Decode: state = `GetB;
`GetB: state = `ALUOp;

`ALUOp : begin
           
                // Determine next state based on opcode and op
                casex ({opcode, op})
                    5'b101_00: state = `WriteReg;    // ADD Rd, Rn, Rm
                    5'b101_10: state = `WriteReg;    // AND Rd, Rn, Rm
                    5'b101_01: state = `UpdateFlags; // CMP Rn, Rm
                    5'b101_11: state = `WriteReg;    // MVN Rd, Rm
                    default: state = `Wait;
                endcase
            end

`WriteReg:  state = `Wait;
`WriteImm:  state = `Wait;         
`UpdateFlags:state = `Wait;
`Shift:   state = `Wait;
default:  state = `Wait;

        endcase

 case (state)
    
 `Wait     :   {w, write, asel, bsel, vsel, nsel, loada, loadb, loadc, loads} = 13'b1_0_0_0_00_001_0_0_0_0; // Rm
`Decode    :   {w, write, asel, bsel, vsel, nsel, loada, loadb, loadc, loads} = 13'b0_0_0_0_00_100_1_0_0_0; // Rn load a =1 loadRn to A
`GetB      :   {w, write, asel, bsel, vsel, nsel, loada, loadb, loadc, loads} = 13'b0_0_0_0_00_001_0_1_0_0; // Rm loadb=1 load Rm to B
`ALUOp     :   {w, write, asel, bsel, vsel, nsel, loada, loadb, loadc, loads} = 13'b0_0_0_0_00_000_0_0_1_0; //     loadc=1 load result into C
`WriteReg  :   {w, write, asel, bsel, vsel, nsel, loada, loadb, loadc, loads} = 13'b0_1_0_0_00_010_0_0_0_0; // Rd write=1 write the ALUop result = vsel=00 =C into Rd
`WriteImm  :   {w, write, asel, bsel, vsel, nsel, loada, loadb, loadc, loads} = 13'b0_1_0_0_10_100_0_0_0_0; // Rn ,sximm8 ,write=1 MOV Rn, #<im8>  deal with immidate values 
`UpdateFlags :  {w, write, asel, bsel, vsel, nsel, loada, loadb, loadc, loads} = 13'b0_0_0_0_00_000_0_0_0_1; //loads=1 update the flag for cmp
`Shift       :  ;
 default: {w, write, asel, bsel, vsel, nsel, loada, loadb, loadc, loads} = 13'b0_0_0_0_00_000_0_0_0_0;
endcase // output 

 

    end
end
endmodule


