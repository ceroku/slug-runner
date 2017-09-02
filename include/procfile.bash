
yaml-esque-keys() {
	declare desc="Get process type keys from colon-separated structure"
	while read -r line || [[ -n "$line" ]]; do
		[[ "$line" =~ ^#.* ]] && continue
		key=${line%%:*}
		echo "$key"
	done <<< "$(cat)"
}

yaml-esque-get() {
	declare desc="Get key value from colon-separated structure"
	declare key="$1"
	local inputkey cmd
	while read -r line || [[ -n "$line" ]]; do
		[[ "$line" =~ ^#.* ]] && continue
		inputkey=${line%%:*}
		cmd=${line#*:}
		if [[ "$inputkey" == "$key" ]]; then
			echo "$cmd"
		fi
	done <<< "$(cat)"
}

procfile-parse() {
	declare desc="Get command string for a process type from Procfile"
	declare type="$1"
	# shellcheck disable=SC2154
	cat "$HOME/Procfile" | yaml-esque-get "$type"
}

procfile-start() {
	declare desc="Run process type command from Procfile through exec"
	declare type="$1"
	local processcmd
	processcmd="$(procfile-parse "$type")"
	if [[ -z "$processcmd" ]]; then
		echo "Proc entrypoint ${type} does not exist. Please check your Procfile"
		exit 1
	else
		procfile-exec "$processcmd"
	fi
}

procfile-exec() {
	declare desc="Run as unprivileged user with Heroku-like env"
	procfile-load-profile
	cd "$HOME" || return 1
	exec $(eval echo "$@")
}

procfile-load-profile() {
	shopt -s nullglob
	for file in /etc/profile.d/*.sh; do
		# shellcheck disable=SC1090
		source "$file"
	done
	mkdir -p "$HOME/.profile.d"
	for file in $HOME/.profile.d/*.sh; do
		# shellcheck disable=SC1090
		source "$file"
	done
	shopt -u nullglob
	hash -r
}

# procfile-release() {
# 	declare desc="Releases an app based on Procfile"
# 	title "Launching..."
# 	procfile-start | indent
# 	procfile-health
# 	echo "Released v1"
# 	echo "https://demo-app.herokuapp.com/ deployed to Heroku"
# }
