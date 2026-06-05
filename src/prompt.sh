#
# Copyright (c) Sebastian Kucharczyk <kuchen@kekse.biz>
# https://kekse.biz/  https://github.com/kekse1/prompt/
# v2.11.2
#
# Copy this script to '/etc/profile.d/prompt.sh'.
# 

#
# you can set this variables directly in the shell (while
# using it). it won't be confirmed, but the behavior will
# instantaneously change.
#
_TERMUX=0
_ANSI=1
_MULTI_LINE=1
_DEPTH=4
_REST_STRING="..."
_COUNT=1
_HOSTNAME=1
_USERNAME=1
_LOAD=1
_DATE=1
_DATE_FORMAT_ONE='%H:%M:%S'
_DATE_FORMAT_TWO='%j'
_LIST=0
_TTY=1
_CODE=1
_SUCCESS=0
_SPACE=1
_NEWLINE=1
_LINK=1
_CHANGE=1
_SLASH=" ❯ "
#_SLASH="/"
#_SLASH=""

#
_list()
{
	local _color="yes"; [[ $_ANSI -eq 0 ]] && _color="no"
	local data="$(\ls -C --group-directories-first --color=${_color})"
	[[ ${#data} -gt 0 ]] && echo -e "\n${data}\n"
}

#
if [[ $_TERMUX -ne 0 ]]; then
	_DEPTH=3
	_DATE=1
	_HOSTNAME=0
	_USERNAME=1
	_LOAD=0
	#_COUNT=0
	_TTY=0
	_SLASH="" # i had problems w/ it on termux..
fi

#
ps1Prompt()
{
	#
	local ret=$?

	#
	startFG()
	{
		[[ $_ANSI -ne 0 ]] && PS1="$PS1"'\[\033[38;2;'"$1;$2;$3"'m\]'
	}

	startBG()
	{
		[[ $_ANSI -ne 0 ]] && PS1="$PS1"'\[\033[48;2;'"$1;$2;$3"'m\]'
	}

	startBold()
	{
		[[ $_ANSI -ne 0 ]] && PS1="$PS1"'\[\033[1m\]'
	}

	ansiReset()
	{
		[[ $_ANSI -ne 0 ]] && PS1="$PS1"'\[\033[m\]'
	}

	write()
	{
		PS1+="$*"
	}

	#
	PS1=""

	#
	local jobCount=`jobs -p | wc -l`

	#
	local listed=0

	if [[ $_LIST -ne 0 && $_last_directory != "`cwd`" ]]; then
		listed=1
		_list
	fi

	#
	startFG 180 115 25
	write ' » '
	ansiReset
	local user_host=0

	#
	if [[ $_USERNAME -ne 0 ]]; then
		if [[ `id -u` -eq 0 ]]; then
			startFG 255 60 10
			startBG 100 10 10
			startBold
		elif [[ `id -g` -eq 0 ]]; then
			startFG 255 10 210
			startBold
		else
			#startFG 180 210 20
			startFG 255 255 0
		fi

		write "`id -nu`"
		ansiReset
		user_host=1
	fi

	if [[ $_HOSTNAME -ne 0 ]]; then
		write '@'
		startFG 255 130 0
		#write "$HOSTNAME"
		write "`hostname`"
		ansiReset
		user_host=1
	fi

	[[ $user_host -ne 0 ]] && write ' '

	#
	if [[ $_TTY -ne 0 ]]; then
		startFG 60 150 210
		write ' ['
		startFG 160 220 255
		write "`ps -p $$ -o tty=`"
		startFG 60 150 210
		write '] '
		ansiReset
	fi

	#
	if [[ $_COUNT -ne 0 ]]; then
		#
		write '  '
		startFG 70 255 200
		write "`find -maxdepth 1 -mindepth 1 -type d | wc -l`"
		startFG 180 255 0
		#startBold
		write ' ⧜ '
		ansiReset
		startFG 70 230 255
		write "`find -maxdepth 1 -mindepth 1 -type f | wc -l`"
		ansiReset
	fi

	#
	if [[ $_DATE -ne 0 && -n "$_DATE_FORMAT_ONE" ]]; then
		write '      ' #4
		startFG 150 220 0
		write "`date +"$_DATE_FORMAT_ONE"`"
		if [[ -n "$_DATE_FORMAT_TWO" ]]; then
			startFG 210 140 10
			write '/'
			startFG 255 180 0
			write "`date +"$_DATE_FORMAT_TWO"`"
			startFG 255 255 0
		fi
		write ' '
		ansiReset
	fi
	
	#
	if [[ $_LOAD -ne 0 && -r /proc/loadavg ]]; then
		local one; local five; local fifteen; local rest;
		read one five fifteen rest </proc/loadavg
		write '   '
		startFG 255 90 120
		write "$one "
		#startFG 255 90 210
		startFG 255 90 240
		write "$five "
		startFG 170 90 255
		write "$fifteen "
		ansiReset
	fi

	#
	[[ $_MULTI_LINE -ne 0 ]] && write "\n  "
	
	#
	local didResult=0

	if [[ $ret -eq 0 ]]; then
		if [[ $_SUCCESS -ne 0 ]]; then
			write ' '
			startBG 170 230 70
			startFG 0 0 0
			write ' ✔ '
			didResult=1
		fi
	else
		write ' '
		startBG 210 45 25
		startFG 255 255 255

		if [[ $_CODE -eq 0 ]]; then
			write ' ✘ '
		else
			startBold
			write " $ret "
		fi

		didResult=1
	fi

	ansiReset

	[[ $didResult -eq 0 && $_SPACE -eq 0 ]] && write ' '

	#
	if [[ $jobCount -gt 0 ]]; then
		[[ $_SPACE -eq 0 ]] || write ' '
		startBG 140 30 140
		startFG 190 240 50
		startBold
		write " $jobCount "
		ansiReset
	fi
	
	#
	[[ $_SPACE -eq 0 ]] || write ' '
	startBG 95 160 205
	startFG 0 0 0
	local path="$(getBase $_DEPTH "`pwd`")"
	if [[ -n "$_SLASH" ]]; then
		local slash="\033[39m${_SLASH}\033[38;2;0;0;0m";
		path="${path//\//${slash}}"
	fi
	write " ${path} "
	ansiReset
	write ' '
	
	if [[ $_LINK -ne 0 && "`pwd`" != "`cwd`" ]]; then
		startBG 120 60 0
		startFG 255 210 0
		startBold
		write ' ⧜ '
		ansiReset
		write ' '
	fi

	if [[ $_CHANGE -ne 0 && "`cwd`" != "$_last_directory" ]]; then
		startBG 220 180 10
		startFG 10 20 30
		#startBold
		write ' ᱙ '
		ansiReset
		write ' '
	fi

	#
	[[ $_NEWLINE -ne 0 && $listed -eq 0 ]] && echo

	#
	_last_directory="`cwd`"
	export PS1
}

export PROMPT_COMMAND=ps1Prompt

#
getBase()
{
	local _depth=$1
	shift
	local _dir="$*"
	local res=""
	local slashCount=0

	if [[ ${_dir} == "/" ]]; then
		echo '/'
		return
	fi

	while [[ "${_dir: -1}" == "/" ]]; do
		_dir="${_dir::-1}"
	done

	local homeLen=${#HOME}
	
	if [[ "$_dir" == "$HOME" ]]; then
		_dir="~"
	elif [[ "${_dir:0:$(($homeLen + 1))}" == "$HOME/" ]]; then
		_dir="~${_dir:$homeLen}"
	fi

	local i; local j; local inHome; local upper;
	for (( i=${#_dir}-1; i >= 0; i-- )); do
		if [[ ${_dir:$i:1} == "/" ]]; then
			let slashCount=$slashCount+1
			res="/${res}"

			if [[ $slashCount -eq $_depth ]]; then
				inHome=0
				upper=""

				for (( j=$i-1; j >= 0; j--)); do
					if [[ "${_dir:$j:1}" != "/" ]]; then
						upper="${_dir:$j:1}${upper}"
					fi
					
					if [[ "$upper" == "~" ]]; then
						inHome=1
						break
					fi
				done

				if [[ $inHome -ne 0 ]]; then
					res="~${res}"
				elif [[ $i -gt 0 ]]; then
					res="${_REST_STRING}${res}"
				fi
				break
			fi
		else
			res="${_dir:$i:1}${res}"
		fi
	done

	echo "$res"
}

#
cwd()
{
	echo "$(realpath "`pwd`")"
}

_last_directory="`cwd`"

#
