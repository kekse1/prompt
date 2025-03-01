#
# Copyright (c) Sebastian Kucharczyk <kuchen@kekse.biz>
# https://kekse.biz/ https://github.com/kekse1/prompt/
# v2.4.0
#
# Copy this script to '/etc/profile.d/prompt.sh'.
# 
# BUT MAYBE other scripts or so override this `$PS1`
# configuration ('/etc/profile', '/etc/bash.bashrc',
# maybe '~/.bashrc' or '~/.profile') .. in this case
# try to find and remove 'em, using `grep -r PS1` ..
#

#
_TERMUX=0
_ANSI=1
_MULTI_LINE=1
_SLASHES=4
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

#
alias _list="ls"
#alias _list="ls -m"

#
if [[ $_TERMUX -ne 0 ]]; then
	_SLASHES=3
	_DATE=1
	_HOSTNAME=0
	_USERNAME=0
	_LOAD=0
	#_COUNT=0
fi

#
_last_directory="`pwd`"

#
ps1Prompt()
{
	#
	ret=$?

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
		PS1="$PS1$*"
	}

	getBase()
	{
		_depth=$1
		shift
		_dir="$*"
		res=""
		slashCount=0

		if [[ ${_dir} == "/" ]]; then
			write ' / '
			return
		fi

		while [[ "${_dir: -1}" == "/" ]]; do
			_dir="${_dir::-1}"
		done

		homeLen=${#HOME}
		
		if [[ "$_dir" == "$HOME" ]]; then
			_dir="~"
		elif [[ "${_dir:0:$(($homeLen + 1))}" == "$HOME/" ]]; then
			_dir="~${_dir:$homeLen}"
		fi

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

		write " $res "
	}

	#
	PS1=""

	#
	jc=`jobs -p | wc -l`

	#
	if [[ $_LIST -ne 0 && $_last_directory != "`pwd`" ]]; then
		_list
	fi

	#
	startFG 180 115 25
	write ' » '
	ansiReset
	user_host=0

	#
	if [[ $_USERNAME -ne 0 ]]; then
		if [[ `id -u` -eq 0 ]]; then
			startBG 200 20 20
		elif [[ `id -g` -eq 0 ]]; then
			startFG 200 20 20
		else
			startFG 225 245 70
		fi

		startBold
		write "`id -nu`"
		ansiReset
		user_host=1
	fi

	if [[ $_HOSTNAME -ne 0 ]]; then
		write '@'
		startFG 245 195 65
		#write "$HOSTNAME"
		write "`hostname`"
		ansiReset
		user_host=1
	fi

	[[ $user_host -ne 0 ]] && write ' '

	#
	if [[ $_TTY -ne 0 ]]; then
		#startFG 110 160 190
		startFG 110 180 60
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
		read one five fifteen rest </proc/loadavg
		startFG 180 250 0
		write "$one $five $fifteen "
		ansiReset
	fi

	#
	if [[ $_COUNT -ne 0 ]]; then
		#
		startFG 190 60 250
		write "`find -maxdepth 1 -type f | wc -l`"
		startFG 200 220 20
		write '/'
		startFG 250 60 180
		write "$((`find -maxdepth 1 -type d | wc -l`-1)) "
		ansiReset
	fi

	#
	[[ $_MULTI_LINE -ne 0 ]] && write "\n "
	
	#
	if [[ $ret -eq 0 ]]; then
		startBG 170 230 70
		startFG 0 0 0
		write ' ✔ '
	else
		startBG 210 45 25
		startFG 255 255 255
		write ' ✘ '
	fi

	ansiReset

	#
	if [[ $jc -gt 0 ]]; then
		write ' '
		startBG 140 30 140
		startFG 255 255 255
		write " $jc "
		ansiReset
	fi
	
	#
	write ' '
	startBG 95 160 205
	startFG 0 0 0
	getBase $_SLASHES "`pwd`"
	ansiReset
	write ' '

	#
	_last_directory="`pwd`"
	export PS1
}

export PROMPT_COMMAND=ps1Prompt

