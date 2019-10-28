#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
	int x,y;
	printf(1,"Hello Test Code\n%d ",waitx(&x,&y));
	printf(1,"%d %d\n",x,y);
	exit();
}