module top_cpu(
    input wire clk,
    input wire rst
);
wire [63:0] pc;
pc u_pc(
    .clk(clk),
    .rst(rst),
    .pc(pc)
);

reg [63:0] satp;
initial begin
    satp = 64'h8000000100001000;
end
wire [63:0] mmu_o_paddr;
mmu u_mmu(
    .mmu_i_vaddr(pc),
    .mmu_i_satp(satp),    // 来自satp寄存器的PPN
    .mmu_o_paddr(mmu_o_paddr)
);
//虚拟地址
endmodule