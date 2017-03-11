#include <stdio.h>

int main(int argc, char **argv){
	if (!(argc-1)) {
		printf("Usage: ./daemonize 'program'\n");
		exit(1);
	}
	int pid = fork();
	if ( !pid ) {
		close(0);
		close(1);
		close(2);
		system(argv[1]);
	}
	exit(0);
}
