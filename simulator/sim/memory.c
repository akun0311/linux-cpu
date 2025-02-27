#include <stdio.h>
#include <cstdint>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <time.h>
#define CONFIG_MSIZE 0x8000000
#define CONFIG_MBASE 0x80000000
typedef uint64_t word_t;

uint8_t pmem[CONFIG_MSIZE]  = {}; 
void init_mem() {
    srand(time(NULL));    
    // 为每个字节生成随机值
    for (size_t i = 0; i < CONFIG_MSIZE; i++) {
      pmem[i] = rand() % 0x100;  // 确保值在0-255范围内
    }
}
static inline word_t host_read(void *addr, int len) {
  switch (len) {
    case 1: return *(uint8_t  *)addr;
    case 2: return *(uint16_t *)addr;
    case 4: return *(uint32_t *)addr;
    case 8: return *(uint64_t *)addr;
    default: assert(0);
  }
}
uint8_t* guest_to_host(word_t paddr) { return pmem + paddr - CONFIG_MBASE; }

word_t pmem_read(word_t addr, int len){
  return host_read(guest_to_host(addr), len);
}
static inline void host_write(void *addr, int len, word_t data) {
  switch (len) {
    case 1: *(uint8_t  *)addr = data; return;
    case 2: *(uint16_t *)addr = data; return;
    case 4: *(uint32_t *)addr = data; return;
    case 8: *(uint64_t *)addr = data; return;
    default: assert(0);
  }
}
void pmem_write(word_t addr, int len, word_t data) {
  host_write(guest_to_host(addr), len, data);
}


extern "C" uint32_t dpi_instr_mem_read(uint64_t addr){
  if(addr >= CONFIG_MBASE && addr < CONFIG_MBASE + CONFIG_MSIZE){
        //printf("访问的内存地址是0x%lx\n", addr);
		return pmem_read(addr, 4);
	}else{
      printf("你将要访问的内存地址是0x%lx, 超出了内存区域\n", addr);
      return 0;
   }
}


#include <cstdint>
#include <cstdio>
#include "verilated_dpi.h" // For VerilatedDpiOpenVar and other DPI related definitions

extern "C" void dpi_ebreak(){
	printf("下一个要执行的指令是ebreak\n");
}


extern "C" uint64_t dpi_mem_read(uint64_t addr, uint64_t len){
	if(addr == 0) return 0;
	else{
//	printf("要读取的地址是addr=0x%lx, len=%ld, 读取出来的数据是data=%ld\n", addr, len,data);
		uint64_t data = pmem_read(addr, len);
		return data;
	}
}

extern "C" void dpi_mem_write(uint64_t addr, uint64_t data, int len){
	if(addr == 0xa00003f8){
		char ch = data;
		printf("%c", ch);
		fflush(stdout);
	}else{
		pmem_write(addr, len, data);
	}
}

uint32_t  *reg_ptr = NULL;
extern "C" void dpi_read_regfile(const svOpenArrayHandle r) {
  reg_ptr = (uint32_t *)(((VerilatedDpiOpenVar*)r)->datap());
}


