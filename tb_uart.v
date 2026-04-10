module tb_uart;

    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] data_in;

    wire tx_serial;
    wire tx_busy;
    wire [7:0] data_out;
    wire rx_done;

    uart_tx tx (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx_serial(tx_serial),
        .tx_busy(tx_busy)
    );

    uart_rx rx (
        .clk(clk),
        .reset(reset),
        .rx_serial(tx_serial),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        tx_start = 0;
        data_in = 0;

        #20 reset = 0;

        // WAIT BEFORE START
        #20;

        // First data
        data_in = 8'b10101010;
        tx_start = 1;
        #10 tx_start = 0;

        // WAIT UNTIL TX FINISHES
        #500;

        // Second data
        data_in = 8'b11110000;
        tx_start = 1;
        #10 tx_start = 0;

        #600;

        $finish;
    end

endmodule
