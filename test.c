#include "types.h"
#include "user.h"

void dosomething()
{
	float ans = 1.0 , x = 1.267643196469;
	int f = 50;
	while(f--)
	{
		ans*=x;
	}
}

int 
main(int argc, char * argv[])
{
	while(1)
	dosomething();
    exit();
}
