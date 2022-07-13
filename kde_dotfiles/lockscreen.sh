#!/bin/bash
#The script stores the JSON response from reddit for 2 hours in the /tmp folder for faster operation. The script also verifies if the image already exists in your wallpapers folder and avoid to download it again if it exists. There is an optional line that you can uncomment if you want the script to clean up your wallpaper folder to avoid cluttering your disk.

#From what I've seen, there isn't a lot of anime wallpapers on the r/wallpapers community, however, if someone doesn't like that feed, you can easily change the feed used by the script on the APIURL variable, just remember to remove the /tmp/reddit-wallpaper-cache.json file if you've run the script previously to clear the cached list.

# cron example:
# 0 * * * * ~/.local/bin/reddit-wallpaper

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# Cache file to save Reddit api response.
JSONCACHE="/tmp/reddit-wallpaper-cache.json"

# Directory where wallpapers are going to be saved
WPATH=${WALLPAPER_PATH:-"$HOME/Pictures/Wallpapers"}
mkdir -p $WPATH

# We need to change our user agent so Reddit allow us to get the JSON without errors
USERAGENT="Mozilla/5.0 (X11; Linux x86_64; rv:100.0) Gecko/20100101 Firefox/100.0"

APIURL="https://www.reddit.com/r/wallpapers.json?limit=100"
#APIURL="https://www.reddit.com/r/NepalPics.json?limit=100"

# Remove cached response if older than 2 hours.
find $(dirname $JSONCACHE) -name "$(basename $JSONCACHE)" -mmin +120 -exec rm {} \; 2>/dev/null

# uncomment this line to remove wallpapers older than 2 days
# find $(dirname $WPATH) -mtime +2 -exec rm {} \; 2>/dev/null

# exit on error
set -e

# If the cache file doesnt exist, we create it.
if [ ! -f "$JSONCACHE" ]; then
  curl -H "User-Agent: $USERAGENT" $APIURL -s > $JSONCACHE
fi

# loop through the JSON until a valid image is found
while : ; do
  # Get a random item from the returned JSON
  WJSON=$(cat $JSONCACHE | jq -c '.data.children[].data' --raw-output | shuf -n 1)
  # Check if crosspost
  CROSSPOST=$(echo "$WJSON" | jq -c '.crosspost_parent_list[0]' --raw-output)
  if [ "$CROSSPOST" != "null" ]; then
    WJSON=$CROSSPOST
  fi
  WDOMAIN=$(echo "$WJSON" | jq '.domain' --raw-output)
  if [ "$WDOMAIN" == "i.redd.it" ]; then
    break
  fi
  if [ "$WDOMAIN" == "reddit.com" ]; then
    break
  fi
  if [ "$WDOMAIN" == "i.imgur.com" ]; then
    break
  fi
done

# If the item is gallery, pick a random item from the gallery
WISGALLERY=$(echo "$WJSON" | jq '.is_gallery')
if [ "$WISGALLERY" == "true" ]; then
  GITEM=$(echo "$WJSON" | jq -c '.media_metadata' --raw-output | jq -c 'to_entries[] | .value' | shuf -n 1)
  WMIME=$(echo "$GITEM" | jq '.m' --raw-output)
  WEXT=$(basename "$WMIME")
  WID=$(echo $GITEM | jq '.id' --raw-output)
  WURI="https://i.redd.it/$WID.$WEXT"
# If the item is not gallery, obtain the image URL directly
else
  WURI=$(echo "$WJSON" | jq '.url' --raw-output)
fi

echo $WURI

# Get the image name + extension
WNAME=$(basename "$WURI")

FILEPATH="$WPATH/$WNAME"

# If the image doesnt exists in our system, we download it.
if [ ! -f "$FILEPATH" ]; then
  curl "$WURI" -s > $FILEPATH
fi

# Set the image in our KDE system (Replace this to support other DE)
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (i=0;i<allDesktops.length;i++) {{
        d = allDesktops[i];
        d.wallpaperPlugin = 'org.kde.image';
        d.currentConfigGroup = Array('Wallpaper',
                                     'org.kde.image',
                                     'General');
        d.writeConfig('Image', 'file://${FILEPATH}')
    }}
"

# Set the image as lock screen wallpaper too
kwriteconfig5 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file://$FILEPATH"

