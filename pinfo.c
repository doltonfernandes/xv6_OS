#include "types.h"
#include "stat.h"
#include "user.h"
#include "pstat.h"

int
main(int argc,char *argv[])
{
	struct proc_stat p;
	if(getpinfo(&p,atoi(argv[1])) < 0)
	{
		printf(1,"Not Found\n");
		exit();
	}
	printf(1,"--------------\npid = %d\nruntime = %d\nnumrun = %d\ncurr_queue = %d\n",p.pid,p.runtime,p.num_run,p.current_queue);
	for(int j=0;j<5;j++)
	{
		printf(1,"ticks [%d] = %d\n",j+1,p.ticks[j]);
	}
	printf(1,"--------------\n");
	exit();
	return 0;
}

// #include "types.h"
// #include "stat.h"
// #include "user.h"
// #include "pstat.h"

// int
// main(int argc,char *argv[])
// {
// 	struct proc_stat p;
// 	for(int i=0;i<10;i++)
// 	{
// 		getpinfo(&p,4);
// 		printf(1,"%d %d\n",p.current_queue+1,i*100);
// 		sleep(100);
// 	}
// 	exit();
// 	return 0;
// }