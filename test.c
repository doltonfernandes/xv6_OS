#include "types.h"
#include "user.h"

void dosomething(int x)
{
	if(x<1)
	{
		return ;
	}
	dosomething(x-1);
	dosomething(x-2);
}

int 
main(int argc, char * argv[])
{
	int pid = fork();
	if(pid == 0)
	{
		dosomething(40);
		exit();
	}
	int x,y;
	waitx(&x,&y);
	printf(1,"wt = %d , rt = %d\n",x,y);
	exit();
}
