#!/bin/bash
##! @%@ /tmp/video-2.mp4
## ブラウザから実行

defalt_dir="$HOME/Music"

prog=$0

fpath=$1
fpath_base="${fpath%.*}"      # /path/to/video
fpath_dir="${fpath%/*}"       # /path/to
f_name="${fpath##*/}"         # video.mp4
f_base="${f_name%.*}"         # video
f_ext="${f_name##*.}"         # mp4

spath_base="${defalt_dir}/${f_base}"

case $f_ext in
	mp4|MP4) spath0=${spath_base}.m4a;;
	flv|FLV) spath0=${spath_base}.mp3;;
	aac|AAC) spath0=${spath_base}.m4a;;
	*) msg="'$f' is NOT video file. 'flv' or 'mp4' are required."
		zenity --error --text="$msg"
		exit;;
esac

spath=$(zenity --file-selection --save --confirm-overwrite --filename="$spath0" --file-filter="audio (*.mp3 *.m4a *.aac) | *.mp3 *.m4a *.aac *.wav *.wma *.mp4 *.flv *.mpg" --title="Select a saved audio file or directory.")
test $? != 0 && exit

s_name="${spath##*/}"

if [ -z "$s_name" ];then
	spath="$path0"
	s_name="${spath##*/}"
fi

case $s_name in
	*.mp3|*.MP3)
		ffmpeg -y -i "$fpath" -acodec copy "$spath"
		;;
	*.m4a|*.M4A)
		aac="/tmp/${f_base}.aac"
		ffmpeg -y -i "$fpath" -acodec copy "$aac"
		ffmpeg -y -i "$aac" -acodec copy "$spath"
		rm -f "$aac"
		;;
	*.aac|*.AAC)
		ffmpeg -y -i "$fpath" -acodec copy "$spath"
		;;
	?*)
		msg="'$s_name' is invalid file name"
		zenity --error --title="Invalid filename error" --text="$msg"
		exec $prog $fpath
	;;
esac

