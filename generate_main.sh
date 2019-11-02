#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "Usage: $(basename "$0") <source files...>"
	exit 1
fi

echo	'#include <stdio.h>'
echo	'#include <limits.h>'
echo	'#include <stdlib.h>'
echo	'#include <libgen.h>'
echo	''
echo	'int	ft_printf(char *format, ...);'
echo	''
echo	'int	main(int argc, char ** argv)'
echo	'{'
echo	'	if (argc != 2)'
echo	'	{'
echo	'		printf("Usage: %s <test_number>\n", basename(argv[0]));'
echo	'		return(-1);'
echo	'	}'
echo	'	switch (atoi(argv[1]))'
echo	'	{'

# Print all tests from source files as cases, ordered by line.
# Note: I deliberately did not redirect stderr to /dev/null, generated file will
# be corrupted if a test file can't be read!
printf "%s\n" "$(cat "$@" | cat -n | sed -E 's/^[ \t]*([0-9]+)(.*)/case \1: return (printf(\2));/')"

echo	'default: return (printf("Error 418: Coffee not found!"));'
echo	'	}'
echo	'}'
