
if [[ "${BASH_VERSINFO[0]}" -lt "4" ]]; then
	echo "!! Your system Bash is out of date: $BASH_VERSION"
	echo "!! Please upgrade to Bash 4 or greater."
	exit 2
fi

main() {
	set -eo pipefail; [[ "$TRACE" ]] && set -x

	case "$SELF" in
		/start)		procfile-start "$@";;
		/exec)		procfile-exec "$@";;
		*)				echo "No such command:" "$@";
	esac
}
