#! /bin/sh

echo "/* Generated by $0 */"
needcomma=0
types=
while read -r line; do
	[ -z "${line%%#*}" ] && continue # skip comments
	if [ -n "${line}" -a -z "${line%%:*}" ]; then
		[ ${needcomma} -eq 1 ] && printf ",\n};\n\n"
		type="${line#:}"
		[ "${type}" = "end" ] && break
		printf "static const char* res_%s[] = {\n" "${type}"
		needcomma=0
		types="${types}${types:+ }${type}"
	else
		[ ${needcomma} -eq 1 ] && printf ",\n"
		printf "\t\"%s\"" "${line}"
		needcomma=1
	fi
done

echo "typedef struct {"
echo "  const char*  name;"
echo "  const char** res;"
echo "  const size_t size;"
echo "} res_t;"
echo
echo "static const res_t res[] = {"
needcomma=0
for type in ${types}; do
	[ ${needcomma} -eq 1 ] && printf ",\n"
	printf "\t{\"%s\",\tres_%s,\tsizeof(res_%s)/sizeof(res_%s[0])}" "${type}" "${type}" "${type}" "${type}"
	needcomma=1
done
echo
echo "};"
