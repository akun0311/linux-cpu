module stage_z(

);
reg z_reg;
reg z_valid;
wire z_ready_go;

assign z_ready_go = ;
assign z_allow_in = !z_valid || z_ready_go;

always @(posedge clk) begin
    if(reset) begin
        z_valid <= 1'b0;
    end
    else if(z_allow_in) begin
        z_valid <= y_to_z_valid;
    end
end

always @(posedge clk) begin
    if(z_allow_in && y_to_z_valid) begin
        z_reg <= y_to_z_bus;
    end
end


endmodule