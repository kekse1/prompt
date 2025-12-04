#
# Copyright (c) Sebastian Kucharczyk <kuchen@kekse.biz>
# https://kekse.biz/ https://github.com/kekse1/prompt/
# v2.9.3
#
# Copy this script to '/etc/profile.d/prompt.sh'.
#
# And maybe the `getBase()` function is interesting for you,
# too? Call it like `getBase $DEPTH $PWD`, e.g. .. it will
# reduce a bigger directory depth to only the last (n) ..
# with a bit of intelligence, too.
# 

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
_LIST=1
_TTY=1
_CODE=1
_SUCCESS=0
_SPACE=1

#
_list()
{
	local _color="yes"; [[ $_ANSI -eq 0 ]] && _color="no"
	local data="$(command ls -t -C --group-directories-first --color=${_color})"
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
fi

#
_last_directory="`pwd`"

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
	if [[ $_LIST -ne 0 && $_last_directory != "`pwd`" ]]; then
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
			startBG 200 20 20
		elif [[ `id -g` -eq 0 ]]; then
			startFG 200 20 20
		else
			startFG 225 245 70
		fi

		#startBold
		write "`id -nu`"
		ansiReset
		user_host=1
	fi

	if [[ $_HOSTNAME -ne 0 ]]; then
		write '@'
		#startBold
		startFG 240 150 20
		#startFG 110 160 190
		#write "$HOSTNAME"
		write "`hostname`"
		ansiReset
		user_host=1
	fi

	[[ $user_host -ne 0 ]] && write ' '

	#
	if [[ $_TTY -ne 0 ]]; then
		startFG 130 210 90
		write "`ps -p $$ -o tty=` "
		ansiReset
	fi
	
	#
	if [[ $_DATE -ne 0 && -n "$_DATE_FORMAT_ONE" ]]; then
		startFG 110 200 255
		write "`date +"$_DATE_FORMAT_ONE"` "
		if [[ -n "$_DATE_FORMAT_TWO" ]]; then
			startFG 210 140 30
			write "`date +"$_DATE_FORMAT_TWO"` "
		fi
		ansiReset
	fi
	
	#
	if [[ $_LOAD -ne 0 && -r /proc/loadavg ]]; then
		local one; local five; local fifteen; local rest;
		read one five fifteen rest </proc/loadavg
		startFG 180 250 0
		write "$one $five $fifteen "
		ansiReset
	fi

	#
	if [[ $_COUNT -ne 0 ]]; then
		#
		startFG 190 60 250
		write "`find -maxdepth 1 -mindepth 1 -type f | wc -l`"
		startFG 200 220 20
		write '/'
		startFG 250 60 180
		write "`find -maxdepth 1 -mindepth 1 -type d | wc -l`"
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
	write " $(getBase $_DEPTH "`pwd`") "
	ansiReset
	write ' '

	#
	_last_directory="`pwd`"
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

