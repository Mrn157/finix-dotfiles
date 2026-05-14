if [[ "$(tty)" == "/dev/tty1" ]] && [[ -z "$DISPLAY" ]]; then
	exec niri > /dev/null 2>&1
fi
