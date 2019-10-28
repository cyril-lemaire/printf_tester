#!/bin/bash

FT_PRINTF_PATH='../ft_printf_reborn'
LIBNAME='libftprintf.a'
PRINTF_TESTER='printf_tester.c'
FT_PRINTF_TESTER='ft_printf_tester.c'
RED='\033[0;31m'
READABLE_ERR='\033[0;33m'
GREEN='\033[0;32m'
CLRCLR='\033[0m'

printf "${GREEN}Compiling ${FT_PRINTF_PATH}/libftprintf.a${CLRCLR}\n"
make -C $FT_PRINTF_PATH && cp "${FT_PRINTF_PATH}/${LIBNAME}" .

printf "${GREEN}Compiling tester for printf${CLRCLR}\n"
gcc -w -o printf_tester -I$FT_PRINTF_PATH/include -I$FT_PRINTF_PATH/libft -I$FT_PRINTF_PATH $PRINTF_TESTER $LIBNAME >/dev/null

printf "${GREEN}Copying ${PRINTF_TESTER} to ${FT_PRINTF_TESTER}${CLRCLR}\n"
sed 's/printf(/ft_printf(/g' $PRINTF_TESTER > $FT_PRINTF_TESTER

printf "${GREEN}Compiling tester for ft_printf${CLRCLR}\n"
gcc -w -o ft_printf_tester -I$FT_PRINTF_PATH/include -I$FT_PRINTF_PATH/libft -I$FT_PRINTF_PATH $FT_PRINTF_TESTER $LIBNAME >/dev/null

function do_test
{
	exp_output=`./printf_tester $1`
	exp_return=$?
	act_output=`./ft_printf_tester $1`
	act_return=$?
	if [ "${exp_return}" -eq 254 ] ; then
		return 254
	elif [ \( $exp_return -ne $act_return \) -o \( "${exp_output}" != "${act_output}" \) ] ; then
		printf "${RED}TEST #%d Error!\nExpected:${CLRCLR}\n${READABLE_ERR}(%3d)\t\"%s\"${CLRCLR}\n${RED}Instead got:${CLRCLR}\n${READABLE_ERR}(%3d)\t\"%s\"${CLRCLR}\n" $1 "${exp_return}" "${exp_output}" "${act_return}" "${act_output}"
	else
		printf "${GREEN}Test #%d OK!${CLRCLR} [(%3d) \"%s\"]\n" $1 "${act_return}" "${act_output}"
	fi
}

if [ "$#" -lt 1 ] ; then
	let i = 0
	while true ; do
		let i++
		
		do_test $i
		if [ "$?" -eq 254 ] ; then
			break
		fi
	done
fi

for ARG in "$@" ; do
	do_test $ARG
done
