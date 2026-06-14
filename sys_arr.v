module sys_arr #(parameter N = 4)(
               input clk,
               input rst,

               // Streaming inputs
               input [7:0] a_stream [0:N-1], 
               input [7:0] b_stream [0:N-1], 

               // Outputs
               output [15:0] c_out [0:N-1][0:N-1]);

    // Wires connecting the PEs
    wire [7:0] a_wire [0:N-1][0:N-1];
    wire [7:0] b_wire [0:N-1][0:N-1];


    // Auto-skewing of Matrix A

    genvar i;
    generate
        for (i = 0; i < N; i = i+1) begin : A_DELAY
            wire [7:0] a_delayed;

            if (i == 0) assign a_delayed = a_stream[i];
            else begin
                delay #(.D(i)) dly(
                    .clk(clk),
                    .rst(rst),
                    .din(a_stream[i]),
                    .dout(a_delayed)
                );
            end

            assign a_wire[i][0] = a_delayed;
        end
    endgenerate

    // Auto-skewing of Matrix B

    genvar j;
    generate
        for (j = 0; j < N; j = j+1) begin : B_DELAY
            wire [7:0] b_delayed;

            if (j == 0) assign b_delayed = b_stream[j];
            else begin
                delay #(.D(j)) dly(
                    .clk(clk),
                    .rst(rst),
                    .din(b_stream[j]),
                    .dout(b_delayed)
                );
            end

            assign b_wire[0][j] = b_delayed;
        end
    endgenerate


    // Instantiating PEs
    generate
        for (i = 0; i < N; i = i+1) begin : ROW
            for (j = 0; j < N; j = j+1) begin : COLUMN

                wire [7:0] a_out, b_out;
                wire [15:0] sum;

                pe PE(
                    .clk(clk),
                    .rst(rst),
                    .a_in(a_wire[i][j]),
                    .b_in(b_wire[i][j]),
                    .a_out(a_out),
                    .b_out(b_out),
                    .sum(sum)
                );

                assign c_out[i][j] = sum;

                // Feeding to the next PE
                if (j < N-1) assign a_wire[i][j+1] = a_out;
                if (i < N-1) assign b_wire[i+1][j] = b_out;
            end
        end
    endgenerate

endmodule
