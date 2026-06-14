`timescale 1ns/1ps

module tb_systolic_arr;

parameter N = 4;
reg clk;
reg rst;

// Inputs
reg [7:0] a_stream [0:N-1];
reg [7:0] b_stream [0:N-1];

// Outputs
wire [15:0] c_out [0:N-1][0:N-1];

// Instantiating UUT
sys_arr #(N) uut (
    .clk(clk),
    .rst(rst),
    .a_stream(a_stream),
    .b_stream(b_stream),
    .c_out(c_out)
);

// Clock generation
always #5 clk = ~clk;

integer i;
initial begin
    clk = 0;
    rst = 1;

    // Initialisation
    for (i = 0; i < N; i = i+1) begin
        a_stream[i] <= 0;
        b_stream[i] <= 0;
    end

    #10 rst = 0;

    // A = [1,  2,  3,  4
    //      5,  6,  7,  8,
    //      9, 10, 11,  12,
    //      13, 14, 15, 16]

    // B = [1,  2,  3,  4
    //      5,  6,  7,  8,
    //      9, 10, 11,  12,
    //      13, 14, 15, 16]


    // Cycle 1
    @(posedge clk);
    a_stream[0]<=1;  a_stream[1]<=5;  a_stream[2]<=9;  a_stream[3]<=13; //Row-wise streaming
    b_stream[0]<=1;  b_stream[1]<=2;  b_stream[2]<=3;  b_stream[3]<=4; //Column-wise streaming

    // Cycle 2
    @(posedge clk);
    a_stream[0]<=2;  a_stream[1]<=6;  a_stream[2]<=10; a_stream[3]<=14;
    b_stream[0]<=5;  b_stream[1]<=6;  b_stream[2]<=7;  b_stream[3]<=8;

    // Cycle 3
    @(posedge clk);
    a_stream[0]<=3;  a_stream[1]<=7;  a_stream[2]<=11; a_stream[3]<=15;
    b_stream[0]<=9;  b_stream[1]<=10; b_stream[2]<=11; b_stream[3]<=12;

    // Cycle 4
    @(posedge clk);
    a_stream[0]<=4;  a_stream[1]<=8;  a_stream[2]<=12; a_stream[3]<=16;
    b_stream[0]<=13;  b_stream[1]<=14; b_stream[2]<=15; b_stream[3]<=16;
    
    // Stop feeding
    @(posedge clk);
    for (i = 0; i < N; i = i+1) begin
        a_stream[i] <= 0;
        b_stream[i] <= 0;
    end

    repeat(10) @(posedge clk); //Waiting for pipeline flush

    $finish;
end

integer j,k;
always @(posedge clk) begin
    $display("T=%0t", $time);
    for (j = 0; j < N; j = j+1) begin
        for (k = 0; k < N; k = k+1) begin
            $write("%5d", c_out[j][k]);
        end
        $write("\n");
    end
end

endmodule
