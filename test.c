#include "types.h"
#include "stat.h"
#include "user.h"
#include "pstat.h"

int
main(int argc,char *argv[])
{
	while(1)
	{
		volatile int x = 1;
		x++;
	}
	exit();
	return 0;
}