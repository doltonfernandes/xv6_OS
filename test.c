#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
	fork();
	fork();
	while(1);
	exit();
	return 0;
}