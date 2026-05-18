if [[ "$(tty)" == "/dev/tty1" ]] && [[ -z "$DISPLAY" ]]; then
	exec dbus-run-session niri --session > /dev/null 2>&1
fi
