

module stage_y(
    input wire clk,
    input wire reset,

    input wire   x_to_y_bus,
    output wire  y_to_z_bus,

    input wire x_to_y_valid,
    input wire  z_allow_in,
    output wire y_allow_in,
    output wire y_to_z_valid
);

reg y_reg;
reg y_valid;
wire   y_ready_go   = xxx;
assign y_allow_in   = !y_valid || (y_ready_go && z_allow_in);
assign y_to_z_valid = y_valid && y_ready_go;

always @(posedge clk) begin
    if(reset) begin
        y_valid <= 1'b0;
    end
    else if(y_allow_in && x_to_y_valid) begin
        y_valid <= 1'b1;
    end
    else if(y_allow_in && !x_to_y_valid) begin
        y_valid <= 1'b0;
    end
    //上面的代码等价于下面这样
    // else if(y_allow_in) begin
    //     y_valid <= x_to_y_valid;
    // end
end

always @(posedge clk) begin
    if(y_allow_in && x_to_y_valid) begin
        y_reg <= x_to_y_bus
    end
end

endmodule