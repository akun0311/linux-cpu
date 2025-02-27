module stallable_pipeline
(
    parameter WIDTH = 100
)
(
    input               clk,
    input               rst,
    input               validin,
    input [WIDTH-1 :0]  datain,
    output              out_allow,
    output              validout,
    output[WIDTH-1 : 0] dataout
)

//regF_ready_go=1'b1代表y的工作做完了，可以流向下一个流水段。
//regF_valid 为1表示当前时钟周期存在有效的数据，其值为0表示当前时钟周期为空
reg             pipe1_valid;
reg [WIDTH-1:0] pipe1_data;


// wire pipe1_ready_go         = ....;
// wire pipe1_allowin          = !pipe1_valid || pipe1_ready_go && pipe2_allowin;
// wire pipe1_to_pipe2_valid   =  pipe1_valid && pipe1_ready_go;

//pipeline stage1
always @(posedge clk) begin
    if(rst) begin
        pipe1_valid <= 1'b0;
    end 
    else if(pipe1_allow_in) begin
        pipe1_valid <= validin;
    end
    if(validin && pipe1_allowin) begin
        pipe1_data <= datain;
    end
end

//pipeline stage2
reg             pipe2_valid;
reg [WIDTH-1:0] pipe2_data;
wire pipe2_allow_in;
wire pipe2_ready_go;
wire pipe2_to_pipe3_valid;

assign pipe2_ready_go       = ....;
assign pipe2_allow_in       = !pipe2_valid || pipe2_ready_go && pipe3_allowin;
assign pipe2_to_pipe3_valid =  pipe2_valid && pipe2_ready_go;



always @(posedge clk) begin
    if(rst) begin-
        pipe2_valid <= 1'b0;
    end
    else if(pipe2_allowin) begin
        pipe2_valid <= pipe1_to_pipe2_valid;
    end
    if(pipe1_to_pipe2_valid && pipe2_allow_in) begin
        pipe2_data <= pipe1_data;
    end

end



//pipeline stage3
reg             pipe3_valid;
reg [WIDTH-1:0] pipe3_data;

wire pipe3_allow_in;
wire pipe3_ready_go;

assign pipe3_ready_go = ...;
assign pipe3_allow_in = !pipe3_valid || pipe3_ready_go && out_allow;

always @(posedge clk) begin
    if(rst) begin
        pipe3_valid <= 1'b0;
    end
    else if(pipe3_allowin) begin
        pipe3_valid <= pipe2_to_pipe3_valid;
    end
end
assign validout = pipe3_valid && pipe3_ready_go;
assign dataout  = pipe3_data;

endmodule