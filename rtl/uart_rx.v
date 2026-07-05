module uart_rx
#(
    parameter DATA_BITS = 8
)
(
    input clk,
    input rst,

    input baud_tick,

    input rx,

    output reg [DATA_BITS-1:0] rx_data,
    output reg rx_done
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;

reg [DATA_BITS-1:0] shift_reg;

reg [3:0] bit_count;

always @(posedge clk)
begin

    if(rst)
    begin

        state <= IDLE;

        shift_reg <= 0;

        bit_count <= 0;

        rx_data <= 0;

        rx_done <= 0;

    end

    else
    begin

        rx_done <= 0;

        case(state)

        IDLE:
        begin

            if(rx == 1'b0)
            begin

                state <= START;

            end

        end

        START:
        begin

            if(baud_tick)
            begin

                state <= DATA;

                bit_count <= 0;

            end

        end

        DATA:
        begin

            if(baud_tick)
            begin

                shift_reg <= {rx, shift_reg[DATA_BITS-1:1]};
                              bit_count <= bit_count + 1;

                if(bit_count == DATA_BITS-1)
                begin
                    state <= STOP;
                end

            end

        end

        STOP:
        begin

            if(baud_tick)
            begin

                if(rx == 1'b1)
                begin
                    rx_data <= shift_reg;
                    rx_done <= 1'b1;
                end

                state <= IDLE;

            end

        end

        default:
        begin
            state <= IDLE;
        end

        endcase

    end

end

endmodule
