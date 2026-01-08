module counter (  input clk,              
                  input rstn,             
                  output reg[3:0] out); 

  // This always block will be triggered at the rising edge of clk (0->1)
  // Once inside this block, it checks if the reset is 0, if yes then change out to zero
  // If reset is 1, then design should be allowed to count up, so increment counter
  always @ (posedge clk) begin
    if (! rstn)
      out <= 0;
    else
      out <= out + 1;
  end
endmodule
