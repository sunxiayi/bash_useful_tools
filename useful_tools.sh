#!/bin/bash

#############################################################################################################
# Input: word to translate
# Output: word translation; example sentence and its translation
# Example: $ ts pear
#【音标】per
#【词译】梨（树）；梨树；
#【例句】Apple - pear as long as the name implies it tastes like apple pear, apple - pear people called it.
#【句译】苹果梨顾名思义它长的像苹果味道却像梨, 人们就叫它苹果梨.
#【Link】https://www.google.com/search?q=pear
#############################################################################################################
function ts() {
	xml=$(curl -s -H "Accept: application/xml" -H "Content-Type: application/xml" \
	 -X GET "https://dict-co.iciba.com/api/dictionary.php?key=E0F0D336AF47D3797C68372A869BDBC5&w=${1}")
	
	# xpath: extract tree node
	# sed: remove <> tags
	# sed: start from the fifth line till the end	
	pronounce=$(xpath "//ps[last()]" <<< "$xml" 2>/dev/null | sed 's/<\/*[[:alpha:]]*>//g' | sed '5,$d')
	echo -e "$(tput setaf 3)【音标】$pronounce"
	
	word_translation=$(xpath "//acceptation" <<< "$xml" 2>/dev/null | sed 's/<\/*[[:alpha:]]*>//g' | tr -d "\n\r")
	echo -e "$(tput setaf 3)【词译】$word_translation"

	# tr: remove newlines
	orig_example=$(xpath "//sent/orig[last()]" <<< "$xml" 2>/dev/null | 
		sed 's/<\/*[[:alpha:]]*>//g' | sed '3,$d' | tr -d "\n\r")
	echo -e "【例句】$orig_example"

	translated_example=$(xpath "//sent/trans[last()]" <<< "$xml" 2>/dev/null | 
		sed 's/<\/*[[:alpha:]]*>//g' | sed '3,$d' | tr -d "\n\r")
	echo -e "【句译】$translated_example $(tput sgr 0)"
	
	# google link
	echo "$(tput setaf 3)【Link】https://www.google.com/search?q=${1}"
}

#############################################################################################################
# Example: $ temp 2f 37.1
# Translation from fahrenheit to celsius: 37.1 -> 98.7800
#############################################################################################################
function temp() {
	if [ "${1}" = "2c" ]; then 
		result=$(echo "scale=4; (${2}-32)*5/9" | bc)
		echo "Translation from celsius to fahrenheit: ${2} -> $result"
	elif [ "${1}" = "2f" ]; then
		result=$(echo "scale=4; (${2}*9/5)+32" | bc)
		echo "Translation from fahrenheit to celsius: ${2} -> $result"
	else
		echo "Invalid command, please enter 'temp 2c number' or 'temp 2f number'"
	fi
}
