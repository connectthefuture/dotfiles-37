#!/usr/bin/env zsh
jsondata=$(curl -s https://api.github.com/repos/adobe-fonts/source-code-pro/releases)
releaselist=$(echo "$jsondata" | grep "prerelease")
taglist=$(echo "$jsondata" | grep "tag_name")
tagcount=$(echo "$releaselist" | wc -l)
relid=1
for (( i=1; i<=$tagcount; i++ ))
do
    reltype=$(echo "$releaselist" | head -n "$i")
    if [[ "$reltype" == *'"prerelease": false,'* ]]
    then
        relid="$i"
        break
    fi
done
tagid=$(echo "$taglist" | head -n "$relid" | cut -d '"' -f 4)
link="https://github.com/adobe-fonts/source-code-pro/archive/$tagid.tar.gz"
printf "${Yellow}Downloading from $link.${Red}\n"
tmpfolder=$(mktemp -d /tmp/dotfiles.sourcecodepro.XXXXXXXXX)
printf "${Yellow}"
curl -L "$link" > "$tmpfolder/download.tar.gz"
printf "${Red}"
mkdir "$tmpfolder/extract"
tar -xf "$tmpfolder/download.tar.gz" -C "$tmpfolder/extract" --strip-components=1
cp -a "$tmpfolder/extract/TTF/." "$HOME/.fonts"
rm -rf "$tmpfolder"
