#include <npc.h>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "defs.h"
#include "verilated_fst_c.h"

void init_mem();

typedef uint64_t word_t;
static TOP_NAME dut;  			    //CPU
static VerilatedFstC *  m_trace = NULL;  //仿真波形
static word_t           clk_count = 0;

static word_t           sim_time = 0;			//时间
static word_t           max_sim_time = 50;

void npc_single_cycle() {
  dut.clk = 0;  dut.eval();   m_trace->dump(sim_time++);
  dut.clk = 1;  dut.eval();   m_trace->dump(sim_time++);
}
void npc_open_simulation(){
  Verilated::traceEverOn(true);
  m_trace= new VerilatedFstC;
  dut.trace(m_trace, 5);
  m_trace->open("waveform.fst");
}
void npc_reset(int n) {
  dut.rst = 1;
  while (n -- > 0) npc_single_cycle();
  dut.rst = 0;
}

void npc_init() {
  npc_open_simulation();
  npc_reset(1);
}

void npc_close_simulation(){
  m_trace->close();
  printf("波形追踪已完成,可以通过make sim命令查看\n");
}

static const uint32_t img [] = {  
  0x11111111,
  0x22222222,
  0x33333333,
  0x44444444,
  0x55555555,
  0x66666666,
  0x77777777,
  0x88888888,
  0x99999999,  
  0x00100073,  // ebreak (used as nemu_trap)
//0xdeadbeef,  // some data
};
void load_builded_img(){
  memcpy(guest_to_host(RESET_VECTOR), img, sizeof(img));
}
int main(){
    init_mem();
    load_builded_img();
    npc_init();
    for(int i = 0; i < max_sim_time; ++i){
        npc_single_cycle();
    }
    npc_close_simulation();
}
