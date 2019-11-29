#!/bin/bash

# Please update these fields to match your project

FT_PRINTF_PATH='../ft_printf_reborn'
LIBNAME='libftprintf.a'

# Settings

# Change this to toggle systematic remake. Just make sure you give me an
# up-to-date libftprintf.a!
YOUR_MAKE_TARGETS=debug

# If set to true, will also show successful tests output.
# Note: Please only set to commands `true` or `false`, not a value!
SHOW_PASSED_TESTS=true
# Source files tested if no argument is given.
DEFAULT_TEST_FILES=(`find . -name "tests*"`)


PRINTF_TESTER='printf_tester'
FT_PRINTF_TESTER='ft_printf_tester'
GENERATED_C_FILE='main.c'
TEMP_OUT_FILE=`mktemp`
GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
CLRCLR='\033[0m'

if [ $# -gt 0 ]; then
	TEST_FILES=("$@")
else
	TEST_FILES=("${DEFAULT_TEST_FILES[@]}")
fi

printf "${GREEN}Compiling ${FT_PRINTF_PATH}/libftprintf.a${CLRCLR}\n"
make -C $FT_PRINTF_PATH $YOUR_MAKE_TARGET && cp "${FT_PRINTF_PATH}/${LIBNAME}" .

printf "Source files are [${TEST_FILES[@]}]\n"

printf "${GREEN}Generating C main for printf${CLRCLR}\n"
./generate_main.sh "${TEST_FILES[@]}" > $GENERATED_C_FILE

printf "${GREEN}Compiling tester for printf${CLRCLR}\n"
clang -w -g -lm -o $PRINTF_TESTER $GENERATED_C_FILE > /dev/null

printf "${GREEN}Generating C main for ft_printf${CLRCLR}\n"
sed "s/(printf(/(ft_printf(/g" "${GENERATED_C_FILE}" > "${TEMP_OUT_FILE}"
cp "${TEMP_OUT_FILE}" "${GENERATED_C_FILE}"

printf "${GREEN}Compiling tester for ft_printf${CLRCLR}\n"
clang -w -g -lm -o $FT_PRINTF_TESTER $GENERATED_C_FILE $LIBNAME > /dev/null

function get_result
{
	./$1 $2 > $TEMP_OUT_FILE 2>&1
	ret_val=$?
	output=`cat -e ${TEMP_OUT_FILE}`
	if [ "${output}" = "" ]; then
		case "${ret_val}" in
		"0" | "255")
			printf "(%3d) \"%s\"" "${ret_val}" "${output}"
			;;
		"138")
			printf "${RED}BUS ERROR!${CLRCLR}"
			;;
		"139")
			printf "${RED}SEG FAULT!${CLRCLR}"
			;;
		*)
			printf "ERROR (Code ${ret_val})"
		esac
	else
		printf "(%3d) \"%s\"" "${ret_val}" "${output}"
	fi
}

function do_test
{
	actual=`get_result $FT_PRINTF_TESTER $1`
	if [ ! $? ]; then
		actual='crash'
	fi
	expected=`get_result $PRINTF_TESTER $1`
	if [ ! $? ]; then
		expected='crash'
	fi
	if [ "${expected}" != "${actual}" ]; then
		printf "${RED}Test #%d Error! ${ORANGE}printf(%s);\n${RED}Sys: ${ORANGE}%s\n${RED}You: ${ORANGE}%s${CLRCLR}\n" $1 "$(cat "${TEST_FILES[@]}" | head -n $1 | tail -n 1)" "${expected}" "${actual}"
		return 1
	elif $SHOW_PASSED_TESTS; then
		printf "${GREEN}Test #%d OK!${CLRCLR} printf(%s) => %s\n" $1 "$(cat "${TEST_FILES[@]}" | head -n $1 | tail -n 1)" "${expected}"
		return 0
	fi
}

NB_LINES=$(wc -l "${TEST_FILES[@]}" | tail -n1 | sed -E 's/^[ \t]*([0-9]+).*/\1/')
printf "${GREEN}Running all ${NB_LINES} tests!${CLRCLR}\n"

declare -i errors=0
for ((i = 1; i <= $NB_LINES; i++)); do
	do_test $i
	if [ $? -ne 0 ]; then
		let errors++
	fi
done

rm -f "${TEMP_OUT_FILE}"

printf "Final result: "
if [ $errors -eq 0 ]; then
	printf "${GREEN}Congratulation! 0 error found :D${CLRCLR}\n"
else
	printf "${RED}${errors} difference(s) found! :(${CLRCLR}\n"
fi
