// ==================================================
// bin2dec: Convert Binary Number to Decimal
//   and Show on Digital 7-segment LED Display
// ==================================================



// ==================================================
// An Up Counter to Decrease Time Resolution
//
module upcounter(clk,
                 tick);

   input clk;
   output reg [31:0] tick = 0;

   always @(posedge clk)
     tick = tick + 1;

endmodule // upcounter



// ==================================================
// Hex to 7 Segment in Verilog
//
module hexto7segment(hex,
                     segments);

   input [3:0] hex;
   output reg [0:6] segments;

   always @(hex)
     case (hex)
       4'b0000: segments = 7'b0000001;
       4'b0001: segments = 7'b1001111;
       4'b0010: segments = 7'b0010010;
       4'b0011: segments = 7'b0000110;
       4'b0100: segments = 7'b1001100;
       4'b0101: segments = 7'b0100100;
       4'b0110: segments = 7'b0100000;
       4'b0111: segments = 7'b0001111;
       4'b1000: segments = 7'b0000000;
       4'b1001: segments = 7'b0000100;
       4'b1010: segments = 7'b0001000;
       4'b1011: segments = 7'b1100000;
       4'b1100: segments = 7'b0110001;
       4'b1101: segments = 7'b1000010;
       4'b1110: segments = 7'b0110000;
       4'b1111: segments = 7'b0111000;
     endcase

endmodule // hexto7segment



// ==================================================
// Cycle Between Digits at Blazing Speed (2.6ms each)
//
module cycledigits(sw,
                   cycle,
                   an,
                   seg);

   input [15:0] sw;
   input [2:0]  cycle;

   output reg [7:0] an;
   output [0:6] seg;

   reg [3:0]    hex;

   always @(cycle) begin
      an = ~(1 << cycle);
      case (cycle)
        0: hex = sw / 1 % 10;
        1: hex = sw / 10 % 10;
        2: hex = sw / 100 % 10;
        3: hex = sw / 1000 % 10;
        4: hex = sw / 10000 % 10;
        5: hex = sw / 100000 % 10;
        6: hex = sw / 1000000 % 10;
        7: hex = sw / 10000000 % 10;
      endcase
   end

   hexto7segment H0 (hex, seg);

endmodule // cycledigits



// ==================================================
// Binary (I/O Switches) to Decimal (Digital LED Display)
//
module bin2dec(sw,
               clk,
               an,
               seg);

   input [15:0] sw;
   input        clk;

   output [7:0] an;
   output [0:6] seg;

   wire [15:0] led;

   wire [31:0] tick;
   wire [2:0]  cycle;

   assign led = sw;
   assign cycle = tick[19:17];

   cycledigits T0 (sw, cycle, an, seg);
   upcounter C0 (clk, tick);

endmodule // bin2dec



// // ==================================================
// // Top module
// //
// module main;

//    wire [15:0] sw;
//    wire        clk;

//    wire [7:0]  an;
//    wire [0:6]  seg;

//    bin2dec B0 (sw, clk, an, seg);

// endmodule



// // ==================================================
// // Testbench Code
// //
// module bin2dec_tb();

//    reg [15:0] sw;
//    reg        clk;

//    wire [7:0] an;
//    wire [0:6] seg;

//    initial begin
//       $monitor ("sw=%d,an=%b,seg(LSB)=%b", sw, an, seg);
//       sw = 9876;
//       clk = 0;
//       forever #1 clk = !clk;
//    end

//    bin2dec B0 (sw, clk, an, seg);

// endmodule // bin2dec_tb
