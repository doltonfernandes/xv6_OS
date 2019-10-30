#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc,char *argv[])
{
	// struct proc_stat *a=(struct proc_stat *)malloc(NPROC*sizeof(struct proc_stat));
	// getpinfo();
	// while(1)
	// {
		int pid1;
		if((pid1=fork())<0)
		{
			exit();
			return 0;
		}
		if(pid1==0)
		{
			printf(1,"Hello from the insideeeeeeeeee......\n");
			exec(argv[1],argv+1);
			exit();
		}
		else
		{
			// wait();
			int x1,y1;
			waitx(&x1,&y1);
			printf(1,"%d %d\n",x1,y1);
		}
	// }
	exit();
	return 0;
}