module stage_x(


);
reg x_valid;
reg x_ready_go;
wire x_allow_in;

assign x_ready_go = xxx;
assign x_allow_in = !x_valid || (x_ready_go && y_allow_in);
assign x_to_y_valid = x_valid && x_ready_go;

always @(posedge clk) begin
    if(reset) begin
        x_valid <= 1'b0;
    end
    else if(x_allow_in) begin
        x_valid <= 1'b1;
    end
end
//valid只能被reset置零，只能被allow_in置为1
//当reset为1时，valid被置0，那么allow_in就变成了1
//一旦reset变为0时，allow_in就会将valid置1


endmodule