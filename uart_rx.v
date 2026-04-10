module uart_rx (
    input clk,
    input reset,
    input rx_serial,
    output reg [7:0] data_out,
    output reg rx_done
);

    parameter BAUD_DIV = 4;

    reg [3:0] bit_index;
    reg [7:0] shift_reg;
    reg [3:0] baud_count;
    reg receiving;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 0;
            bit_index <= 0;
            rx_done <= 0;
            receiving <= 0;
            baud_count <= 0;
            shift_reg <= 0;
        end 
        else begin
            rx_done <= 0;

            // Start bit detect
            if (!receiving && rx_serial == 0) begin
                receiving <= 1;
                baud_count <= 0;
                bit_index <= 0;
            end 

            else if (receiving) begin
                baud_count <= baud_count + 1;

                // Sample at center of each bit
                if (baud_count == (BAUD_DIV/2)) begin
                    if (bit_index < 8) begin
                        shift_reg[bit_index] <= rx_serial;
                        bit_index <= bit_index + 1;
                    end
                end

                if (baud_count == BAUD_DIV-1) begin
                    baud_count <= 0;

                    if (bit_index == 8) begin
                        data_out <= shift_reg;
                        rx_done <= 1;
                        receiving <= 0;
                    end
                end
            end
        end
    end

endmodule
