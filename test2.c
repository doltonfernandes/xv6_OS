#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
	for(int i=0;i<1e4;i++)
	{
		volatile int x = 1;
		x++;
	}
	printf(1,"Hello-fast\n");
	exit();
	return 0;
}