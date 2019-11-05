#include <stdio.h>
#include <stdlib.h>
#include <libgen.h>
#include <limits.h>
#include <math.h>
#include <float.h>
#include <locale.h>
#include "../ft_printf_reborn/include/ft_printf.h"

int	main(int argc, char ** argv)
{
	struct lconv	*lc;
	t_ldbl_cast n;
	char *s = (char*)&n;
	if (argc != 2)
	{
		printf("Usage: %s <test_number>\n", basename(argv[0]));
		return(-1);
	}
	setlocale(LC_ALL,"");
	lc=localeconv();
	printf("LC_NUMERIC [%d], LC_ALL [%d], Locale (decimal point [%s], grouping [%s], thousands_sep [%s])\n", LC_NUMERIC, LC_ALL, lc->decimal_point, lc->grouping, lc->thousands_sep);
	n.x = (long double)M_PI;
	switch (atoi(argv[1]))
	{
case 1:
	printf("%Lf, %zu\n", n.x, sizeof(long double));
	ft_printf("%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|\n", s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8], s[9], s[10], s[11], s[12], s[13], s[14], s[15]);
	return (ft_printf("[m%*b|e%*b|s%*b]\n", LDBL_MANT_DIG, n.parts.mant, 8 * sizeof(long double) - LDBL_MANT_DIG - 1, n.parts.exp, 1,  n.parts.sign));
default: return (ft_printf("Error 418: Coffee not found!"));
	}
}
