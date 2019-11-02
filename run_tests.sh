#!/bin/bash

# Please update these fields to match your project
FT_PRINTF_PATH='../ft_printf_reborn'
LIBNAME='libftprintf.a'

TEST_FILES=('test'*'.txt')
PRINTF_TESTER='printf_tester'
FT_PRINTF_TESTER='ft_printf_tester'
GENERATED_C_FILE='main.c'
GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
CLRCLR='\033[0m'

if [ $# -ge 1 ]; then
	TEST_FILES=("$@")
fi

echo "Test files: ${TEST_FILES[@]}"

printf "${GREEN}Compiling ${FT_PRINTF_PATH}/libftprintf.a${CLRCLR}\n"
make -C $FT_PRINTF_PATH && cp "${FT_PRINTF_PATH}/${LIBNAME}" .

printf "${GREEN}Generating C main for printf${CLRCLR}\n"
./generate_main.sh ${TEST_FILES[@]} > $GENERATED_C_FILE

printf "${GREEN}Compiling tester for printf${CLRCLR}\n"
gcc -w -o $PRINTF_TESTER $GENERATED_C_FILE $LIBNAME > /dev/null

printf "${GREEN}Generating C main for ft_printf${CLRCLR}\n"
sed -i 's/(printf(/(ft_printf(/g' $GENERATED_C_FILE

printf "${GREEN}Compiling tester for ft_printf${CLRCLR}\n"
gcc -w -o $FT_PRINTF_TESTER $GENERATED_C_FILE $LIBNAME >/dev/null

function do_test
{
	exp_output=`./${PRINTF_TESTER} $1 | cat -e`
	exp_return=$?
	act_output=`./${FT_PRINTF_TESTER} $1 | cat -e`
	act_return=$?
	if [ \( $exp_return -ne $act_return \) -o \( "${exp_output}" != "${act_output}" \) ] ; then
		printf "${RED}Test #%d Error! ${ORANGE}printf(%s);\n${RED}Sys: ${ORANGE}(%3d)\t\"%s\"\n${RED}You: ${ORANGE}(%3d)\t\"%s\"${CLRCLR}\n" $1 "$(cat ${TEST_FILES[@]} | head -n $1 | tail -n 1)" "${exp_return}" "${exp_output}" "${act_return}" "${act_output}"
		return 1
#	else
#		printf "${GREEN}Test #%d OK!${CLRCLR}\tprintf($(cat ${TEST_FILES[@]} | head -n $1 | tail -n 1)) => [(%3d) \"%s\"]\n" $1 "${act_return}" "${act_output}"
	fi
}

NB_LINES=$(wc -l ${TEST_FILES[@]} | tail -n1 | grep -Eo '^\s*[0-9]+')
printf "${GREEN}Running all ${NB_LINES} tests!${CLRCLR}\n"

declare -i errors=0
for ((i=1; i <= $NB_LINES; i++)); do
	do_test $i
	if [ $? -ne 0 ]; then
		let errors++
	fi
done

printf "Final result: "
if [ $errors -eq 0 ]; then
	printf "${GREEN}Congratulations! 0 error found :D${CLRCLR}\n"
else
	printf "${RED}${errors} difference(s) found! :(${CLRCLR}\n"
fi
