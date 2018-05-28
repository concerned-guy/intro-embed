module jk(j, k, q, qn, reset);

   input j;
   input k;

   input reset;

   output reg q;
   output reg qn;

   always @(posedge reset) begin

   end

   always @(j or k) begin
      if (j == 0 && k == 1)
        {q, qn} <= 2'b01;
      else if (j == 1 && k == 0)
        {q, qn} <= 2'b10;
      else if (j == 1 && k == 1)
        {q, qn} <= {qn, q};
   end

endmodule // jk

module main;

   wire [1:0] sw;
   wire [1:0] led;

   wire       btnC;

   jk JK0 (sw[0], sw[1], led[0], led[1], btnC);

endmodule

// module test;

//    reg [1:0]  sw = 0;
//    wire [1:0] led;

//    reg        btnC = 0;

//    initial begin
//       $monitor("j=%b,k=%b,q=%b,qn=%b", sw[0], sw[1], led[0], led[1]);
//       #1 sw = 2'b01;
//       #1 sw = 2'b10;
//       #1 sw = 2'b00;
//       #1 sw = 2'b11;
//    end

//    jk JK1 (sw[0], sw[1], led[0], led[1], btnC);

// endmodule
