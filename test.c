#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
	int pid = fork();
	if(pid<0)
	{
		exit();
	}
	if(pid==0)
	{
		for(int i=0;i<1000000000;i++){}
		sleep(5);
	}
	else
	{
		int x,y;
		waitx(&x,&y);
		printf(1,"%d %d\n",x,y);
	}
	exit();
}