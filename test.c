#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int 
main(int argc, char * argv[])
{
    // int priority;
    // int pid;
    
    // if(argc<3)
    // {
    //     printf(2, "Error: Exiting\n");
    //     exit();
    // }
    // pid = atoi(argv[1]);
    // priority = atoi(argv[2]);
    // if(priority < 0 || priority > 100)
    // {
    //     printf(2, "Invalid priority!\n");
    //     exit();
    // }
    // printf(1, "Process %d\n Priority %d\n", pid, priority);
    // set_priority(pid, priority);
    // exit();
    // int pro1;
    // if((pro1 = fork())==0)
    // {
    //     int pro2;
    //     if((pro2 = fork())==0) {
    //         #ifdef PRIORITY
    //         set_priority(80);
    //         #endif
    //         sleep(atoi(argv[1]));
    //         printf(1, "Exit 1\n");
    //     }
    //     else {
    //         #ifdef PRIORITY
    //         set_priority(50);
    //         #endif
    //         sleep(atoi(argv[2]));
    //         printf(1, "Exit 2\n");
    //     }
    // }
    // else {
    //     #ifdef PRIORITY
    //     set_priority(20);
    //     #endif
    //     sleep(atoi(argv[3]));
    //     printf(1, "Exit 3\n");
    // }
    while(1);
    exit();
}
