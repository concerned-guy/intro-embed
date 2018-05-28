module blink(clk,
             on);
   input clk;
   output reg on = 0;

   reg [63:0] tick = 1;

   always @(posedge clk) begin
      tick = tick + 1;
      if (tick == 100000000) begin
         on <= !on;
         tick <= 1;
      end
   end

endmodule // blink
