module baud_generator(

    input clk,
    input rst,

    output reg baud_tick

);

parameter BAUD_DIV=10417;
reg [15:0] baud_count;
always @(posedge clk)
  begin
    if(rst)
      begin
      baud_tick <=1'b0;
      baud_count <=16'd0;
      end
      else begin
        if(baud_count==BAUD_DIV-1)
          begin
          baud_tick <=1'b1;
          baud_count <=1'b0;
          end
        else
         begin
         baud_count<=baud_count+1;
         baud_tick <=1'b0;
         end
       end
    end
  endmodule
