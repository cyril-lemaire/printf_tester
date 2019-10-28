#include "ft_printf.h"
#include <libgen.h>
#include <string.h>
#include <fcntl.h>
#include "libft.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define BUFFER_SIZE 4096

int main(int argc, char **argv)
{
	if (argc != 2)
	{
		printf("Usage: %s <test_number>", basename(argv[0]));
		return (-2);
	}
	switch (atoi(argv[1]))
	{
		case 1:
			return printf("Hello, World!\n");
		case 2:
			return printf("%5c", '*');
		case 3:
			return printf("%.p", 0);
		case 4:
			return printf("%.p", 1);
		case 5:
			return printf("%.2p", 0);
		case 6:
			return printf("%5.2p", 0);
		default:
			return (-2);
	}
}
