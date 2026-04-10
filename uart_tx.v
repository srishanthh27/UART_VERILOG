module uart_tx (
    input clk,
    input reset,
    input tx_start,
    input [7:0] data_in,
    output reg tx_serial,
    output reg tx_busy
);

    parameter BAUD_DIV = 4;

    reg [3:0] bit_index;
    reg [9:0] shift_reg;
    reg [3:0] baud_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_serial <= 1'b1;
            tx_busy <= 0;
            bit_index <= 0;
            baud_count <= 0;
            shift_reg <= 10'b1111111111;
        end 
        else if (tx_start && !tx_busy) begin
            shift_reg <= {1'b1, data_in, 1'b0}; // stop, data, start
            tx_busy <= 1;
            bit_index <= 0;
            baud_count <= 0;
        end 
        else if (tx_busy) begin
            if (baud_count == BAUD_DIV-1) begin
                baud_count <= 0;

                tx_serial <= shift_reg[bit_index];
                bit_index <= bit_index + 1;

                if (bit_index == 9) begin
                    tx_busy <= 0;
                    tx_serial <= 1'b1;
                end
            end 
            else begin
                baud_count <= baud_count + 1;
            end
        end
    end

endmodule