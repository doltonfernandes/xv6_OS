#include "types.h"
#include "stat.h"
#include "user.h"
int
main(void)
{
	// struct proc_stat *a=(struct proc_stat *)malloc(NPROC*sizeof(struct proc_stat));
	// getpinfo();
	int pid1;
	if((pid1=fork())<0)
	{
		exit();
		return 0;
	}
	if(pid1==0)
	{
		printf(1,"Hello 1\n");
	}
	else
	{
		int x1,y1;
		waitx(&x1,&y1);
		printf(1,"%d %d\n",x1,y1);
	}
	exit();
	return 0;
}