#! /bin/sh

echo "/* Generated by $0 */"
needcomma=0
printedtype=0
while read -r line; do
	[ -z "${line%%#*}" ] && continue # skip comments
	# :type/:end
	if [ -n "${line}" -a -z "${line%%:*}" ]; then
		# Close out the last type.
		[ ${printedtype} -eq 1 ] && printf "%c\n\n" '"'
		type="${line#:}"
		[ "${type}" = "end" ] && break
		printf "#define DEFAULT_%s \"%c\n" $(echo "${type}" | tr '[:lower:]' '[:upper:]') '\'
		needcomma=0
		printedtype=1
	else
	# entry
		# Comma-separate the last entry.
		[ ${needcomma} -eq 1 ] && printf ",%c\n" '\'
		printf "%s" "${line}"
		needcomma=1
	fi
done
