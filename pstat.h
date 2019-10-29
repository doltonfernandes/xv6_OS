#ifndef _PSTAT_H_
#define _PSTAT_H_

#include "param.h"

struct proc_stat {
  int pid; // PID of process
  float runtime; // Runtime of process
  int num_run; // Number of time the process is executed
  int current_queue; // Current assigned queue
  int ticks[5]; // Number of ticks each process has received at each of the 5 priority queue
};

#endif // _PSTAT_H_
