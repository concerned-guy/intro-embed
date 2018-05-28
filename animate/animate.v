// ==================================================
// animate: 7-Segment Display Animation
// ==================================================



// ==================================================
// Counter to get desired resolution
//
module upcounter(clk,
                 tick);

   input clk;
   input btnC;

   output reg [31:0] tick = 0;

   always @(posedge clk)
     tick = tick + 1;

endmodule // upcounter



// ==================================================
// LEDs count execution time in base 2 LSB
module updateled(tick,
                 led);

   input [31:0] tick;
   output reg [0:15] led = 0;

   always @(posedge tick[26])
     led = led + 1;

endmodule // turnleds



// ==================================================
// Update 7 Segment in Verilog
//
module update7segment(millis,
                      mode,
                      pos,
                      an,
                      seg);

   input [63:0] millis;
   input [31:0] mode;
   input [31:0] pos;

   output reg [0:7] an;
   output reg [0:6] seg;

   reg [31:0]       step;

   reg [0:6]        leftbar  = 7'b1111001;
   reg [0:6]        midbar   = 7'b0110110;
   reg [0:6]        rightbar = 7'b1001111;

   reg [0:6]        upsquare   = 7'b0011100;
   reg [0:6]        downsquare = 7'b1100010;
   reg [0:6]        off        = 7'b1111111;

   wire [0:6]       climb[0:7];

   wire [0:6]       digit[0:15];
   wire [0:6]       date[0:7];

   wire [31:0]      dist[0:15];

   wire [31:0]      leftbardist[0:7];
   wire [31:0]      midbardist[0:7];
   wire [31:0]      rightbardist[0:7];

   // ##################################################
   // Begin Data

   assign climb[0] = 7'b1110111; // bottom
   assign climb[1] = downsquare; // downsquare
   assign climb[2] = 7'b0000000; // all on
   assign climb[3] = upsquare;   // upsquare
   assign climb[4] = 7'b0111111; // top
   assign climb[5] = off;        // off
   assign climb[6] = off;        // off
   assign climb[7] = off;        // off

   assign digit[0]  = 7'b0000001;
   assign digit[1]  = 7'b1001111;
   assign digit[2]  = 7'b0010010;
   assign digit[3]  = 7'b0000110;
   assign digit[4]  = 7'b1001100;
   assign digit[5]  = 7'b0100100;
   assign digit[6]  = 7'b0100000;
   assign digit[7]  = 7'b0001111;
   assign digit[8]  = 7'b0000000;
   assign digit[9]  = 7'b0000100;
   assign digit[10] = 7'b0001000;
   assign digit[11] = 7'b1100000;
   assign digit[12] = 7'b0110001;
   assign digit[13] = 7'b1000010;
   assign digit[14] = 7'b0110000;
   assign digit[15] = 7'b0111000;

   assign date[0] = digit[2];
   assign date[1] = digit[0];
   assign date[2] = digit[1];
   assign date[3] = digit[8];
   assign date[4] = digit[0];
   assign date[5] = digit[5];
   assign date[6] = digit[2];
   assign date[7] = digit[8];

   assign dist[0] = 14;
   assign dist[1] = 38;
   assign dist[2] = 64;
   assign dist[3] = 111;
   assign dist[4] = 136;
   assign dist[5] = 160;
   assign dist[6] = 168;
   assign dist[7] = 184;
   assign dist[8] = 208;
   assign dist[9] = 234;
   assign dist[10] = 258;
   assign dist[11] = 266;
   assign dist[12] = 306;
   assign dist[13] = 332;
   assign dist[14] = 356;
   assign dist[15] = 363;

   assign leftbardist[0] = 0;
   assign leftbardist[1] = 3;
   assign leftbardist[2] = 8;
   assign leftbardist[3] = 12;
   assign leftbardist[4] = 14;
   assign leftbardist[5] = 10;
   assign leftbardist[6] = 5;
   assign leftbardist[7] = 2;

   assign rightbardist[0] = leftbardist[7];
   assign rightbardist[1] = leftbardist[6];
   assign rightbardist[2] = leftbardist[5];
   assign rightbardist[3] = leftbardist[4];
   assign rightbardist[4] = leftbardist[3];
   assign rightbardist[5] = leftbardist[2];
   assign rightbardist[6] = leftbardist[1];
   assign rightbardist[7] = leftbardist[0];

   assign midbardist[0] = (leftbardist[0] + rightbardist[0]) / 2;
   assign midbardist[1] = (leftbardist[1] + rightbardist[1]) / 2;
   assign midbardist[2] = (leftbardist[2] + rightbardist[2]) / 2;
   assign midbardist[3] = (leftbardist[3] + rightbardist[3]) / 2;
   assign midbardist[4] = (leftbardist[4] + rightbardist[4]) / 2;
   assign midbardist[5] = (leftbardist[5] + rightbardist[5]) / 2;
   assign midbardist[6] = (leftbardist[6] + rightbardist[6]) / 2;
   assign midbardist[7] = (leftbardist[7] + rightbardist[7]) / 2;

   // End Data
   // ##################################################

   always @(pos) begin
      // Set current anode
      an = ~(1 << pos);

      // Set current cathodes
      case (mode)
        0:                       // Walking Square
          begin
             step = (millis / 100) % 16;
             if (step < 8 && pos == step)
               seg = upsquare;
             else if (step >= 8 && pos == 15 - step)
               seg = downsquare;
             else
               seg = off;
          end
        1:                       // Climbing Bar
          begin
             step = (millis / 100) % 8;
             seg = climb[(step + pos) % 8];
          end
        2:                       // Sweep to Center
          begin
             step = millis % 650;
             seg = off;
             if (step >= dist[leftbardist[pos]] && step < dist[leftbardist[pos]] + 250)
               seg = seg ~^ leftbar;
             if (step >= dist[midbardist[pos]] && step < dist[midbardist[pos]] + 250)
               seg = seg ~^ midbar;
             if (step >= dist[rightbardist[pos]] && step < dist[rightbardist[pos]] + 250)
               seg = seg ~^ rightbar;
          end
        3:
          begin
             seg = date[pos];
          end
      endcase
   end

endmodule // update7segment



// ==================================================
// Animation
//
module animate(clk,
               btnC,
               led,
               an,
               seg);

   input clk;
   input btnC;

   output [0:15] led;
   output [0:7]  an;
   output [0:6]  seg;

   wire [31:0]  tick;
   reg          prev_btnC = 0;

   reg [63:0]   millis = 0;
   reg [31:0]   mode = 2;
   reg [31:0]   pos = 0;

`ifdef __ICARUS__
   always @(posedge tick[10]) begin // Simulations run slower, so speed things up 50 times
`else
   always @(posedge tick[14]) begin // Not simulation
`endif

      // Reset button changes mode
      if (btnC && !prev_btnC) begin
         mode = (mode + 1) % 4;
         millis = 0;
         pos = 0;
      end

      millis = millis + 1;
      pos = (pos + 1) % 8;
      prev_btnC = btnC;

   end

   update7segment D0 (millis, mode, pos, an, seg);
   updateled L0 (tick, led);

   upcounter C0 (clk, tick);

endmodule // animate



// // ==================================================
// // Top module
// //
// module main;

//    wire        clk;
//    wire        btnC;

//    wire [0:15] led;
//    wire [0:7]  an;
//    wire [0:6]  seg;

//    animate A0 (clk, btnC, led, an, seg);

// endmodule



`ifdef __ICARUS__
// ==================================================
// Testbench Code
//
module test;

   reg clk = 0;
   reg btnC = 0;

   wire [0:15] led;
   wire [0:7]  an;
   wire [0:6]  seg;

   initial begin
      $monitor ("an=%b,seg=%b", an, seg);
      forever #1 clk = !clk;
   end

   animate B0 (clk, btnC, led, an, seg);

endmodule // test
`endif
