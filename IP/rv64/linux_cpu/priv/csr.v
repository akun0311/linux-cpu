module csr(

);

reg [63:0] misa;
reg [63:0] mhartid;
reg [63:0] medeleg;
reg [63:0] mideleg;
reg [63:0] mtime;
reg [63:0] mtimecmp;
reg [63:0] mstatus;
reg [63:0] mtvec;
reg [63:0] mip;
reg [63:0] mie;
reg [63:0] mscratch;
reg [63:0] mepc;
reg [63:0] mtval;
reg [63:0] mcause;

endmodule