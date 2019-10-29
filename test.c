#include "types.h"
#include "stat.h"
#include "user.h"
int
main(void)
{
	// struct proc_stat *a=(struct proc_stat *)malloc(NPROC*sizeof(struct proc_stat));
	// getpinfo();
	int f=fork();
	int a,b;
	if(f<0)
	{
		exit();
	}
	if(f==0)
	{
		// Do something
		sleep(5);
		exit();
	}
	else
	{
		waitx(&a,&b);
	}
	printf(1,"%d %d\n",a,b);
	exit();
}