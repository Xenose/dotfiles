#!/bin/dash

notify_user() {
	if [ "$(uname)" = "Darwin" ]; then
		osascript -e "display notification \"$1\""
   elif command -v powershell.exe > /dev/null; then
      powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('$1')"
	elif command -v notify-send > /dev/null; then
      notify-send "$1"
   else
      echo "No program to notify user..."
   fi
}
