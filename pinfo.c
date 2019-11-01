#include "types.h"
#include "stat.h"
#include "user.h"
#include "pstat.h"

int
main(int argc,char *argv[])
{
	struct proc_stat *p = (struct proc_stat *)malloc(64*7*sizeof(struct proc_stat));
	int size = getpinfo(p);
	for(int i=0;i<size;i++)
	{
		printf(1,"--------------\npid = %d\nruntime = %d\nnumrun = %d\ncurr_queue = %d\n",p[i].pid,p[i].runtime,p[i].num_run,p[i].current_queue);
		for(int j=0;j<5;j++)
		{
			printf(1,"tick [%d] = %d\n",j+1,p[i].ticks[j]);
		}
		if(i==size-1)
		{
			printf(1,"--------------\n");
		}
	}
	exit();
	return 0;
}