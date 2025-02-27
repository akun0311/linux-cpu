module pc(
    input wire clk,
    input wire rst,
    output reg [63:0] pc
);


always @(posedge clk) begin
    if(rst) begin
       pc <= 64'd0; 
    end
    else begin
        pc <= pc + 64'd4;
    end
end
endmodule