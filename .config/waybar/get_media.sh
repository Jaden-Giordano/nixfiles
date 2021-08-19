player_name=$(playerctl metadata -f "{{playerName}}")
media=$(playerctl metadata -f "{{artist}} - {{title}}")
player_status=$(playerctl status)

if [ "$player_status" = "Playing" ]
then
  song_status='契'
elif [ "$player_status" = "Paused" ]
then
  song_status=''
else
  song_status='栗'
  exit 1
fi

if [ "$player_name" = "spotify" ]
then
  player="阮"
else
  player="ﱘ"
fi

cut_media=$(echo $media | cut -c 1-25)

echo "$player  $cut_media  $song_status"
