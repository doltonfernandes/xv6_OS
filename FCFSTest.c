#include "types.h"
#include "user.h"

int 
main(int argc, char * argv[])
{
    int pro1;
    if((pro1 = fork())==0)
    {
        int pro2;
        if((pro2 = fork())==0) {
            sleep(atoi(argv[1]));
            printf(1, "Exit 1\n");
        }
        else {
            sleep(atoi(argv[2]));
            printf(1, "Exit 2\n");
        }
    }
    else {
        sleep(atoi(argv[3]));
        printf(1, "Exit 3\n");
    }
    exit();
}
