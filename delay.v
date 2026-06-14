module delay #(parameter D = 1)(
        input clk, 
        input rst,
        input [7:0] din,
        output [7:0] dout);

    reg [7:0] shift_reg [0:D-1];

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < D; i = i+1) begin
                shift_reg[i] <= 8'b0;
            end
        end
        else begin
            shift_reg[0] <= din;
            for (i = 1; i < D; i = i+1) begin
                shift_reg[i] <= shift_reg[i-1];
            end
        end
    end

    assign dout = shift_reg[D-1];
endmodule
