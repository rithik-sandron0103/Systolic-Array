module pe(input clk,
          input rst,
          input [7:0] a_in,
          input [7:0] b_in,
          output reg [7:0] a_out,
          output reg [7:0] b_out,
          output reg [15:0] sum);

    always @(posedge clk) begin
        if (rst) begin
            sum <= 0;
            a_out <= 0;
            b_out <= 0;
        end
        else begin
            sum <= sum + a_in*b_in; // MAC (Multiply Accumulate)
            a_out <= a_in; // Pass right
            b_out <= b_in; // Pass down
        end
    end
endmodule
