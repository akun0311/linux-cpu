module mmu(
    input  wire [63:0] mmu_i_vaddr,
    input  wire [63:0] mmu_i_satp,    // 来自satp寄存器的PPN
    output wire [63:0] mmu_o_paddr
);

wire [63:0] vaddr = mmu_i_vaddr;
wire [63:0] satp  = mmu_i_satp;
//虚拟地址
wire [11:0] pg_offset   = vaddr[11:0];
wire [8:0]  vpn0        = vaddr[20:12]; //8BIT
wire [8:0]  vpn1        = vaddr[29:21];
wire [8:0]  vpn2        = vaddr[38:30]; //第一级页表

wire [3:0]  satp_mode   = satp[63:60];
wire [15:0] satp_asid   = satp[59:44];
wire [43:0] satp_ppn    = satp[43: 0];

//satp_ppn是基址寄存器
wire [43:0]a  = satp_ppn << 12;

endmodule