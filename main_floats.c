#include <stdio.h>
#include <stdlib.h>
#include <libgen.h>
#include <limits.h>
#include <math.h>
#include <float.h>
#include <locale.h>
#include "../ft_printf_reborn/include/ft_printf.h"

void float_repr(long double f)
{
	t_ldbl_cast n;
	char *s = (char*)&n;
	
	n.val = f;
	printf("Printing long double %Lf (%zuB)\n", n.val, sizeof(long double));
	ft_printf("%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|%08hhb|\n", s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8], s[9], s[10], s[11], s[12], s[13], s[14], s[15]);
	ft_printf("[m%0*lb|e%0*lb|s%0*lb]\n", LDBL_MANT_DIG, n.parts.mant, 8 * sizeof(long double) - LDBL_MANT_DIG - 1, n.parts.exp, 1,  n.parts.sign);
}

int	main(int argc, char ** argv)
{
	struct lconv	*lc;
	long double numbers[] = {1.0, M_PI, 0, 42.42e42,1000000,1024*1024};
	
	setlocale(LC_ALL,"");
	lc=localeconv();
	printf("LC_NUMERIC [%d], LC_ALL [%d], Locale (decimal point [%s], grouping [%s], thousands_sep [%s])\n", LC_NUMERIC, LC_ALL, lc->decimal_point, lc->grouping, lc->thousands_sep);
	printf("long double %zu long unsigned %zu ldbl_cast %zu\n", sizeof(long double), sizeof(long unsigned), sizeof(t_ldbl_cast));
	ft_printf("[m%zu|e%zu|s%zu]\n", LDBL_MANT_DIG, LDBL_EXP_DIG, 1);
	for (size_t i = 0; i < sizeof(numbers) / sizeof(*numbers); ++i)
		float_repr(numbers[i]);
	return (0);
}
