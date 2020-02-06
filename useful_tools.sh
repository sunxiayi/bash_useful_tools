#!/bin/bash

#############################################################################################################
# Input: word to translate
# Output: word translation; example sentence and its translation
# Example: $ ts pear
#【词译】梨（树）；梨树；
#【例句】Apple - pear as long as the name implies it tastes like apple pear, apple - pear people called it.
#【句译】苹果梨顾名思义它长的像苹果味道却像梨, 人们就叫它苹果梨.
#############################################################################################################
function ts() {
	xml=$(curl -s -H "Accept: application/xml" -H "Content-Type: application/xml" \
	 -X GET "https://dict-co.iciba.com/api/dictionary.php?key=E0F0D336AF47D3797C68372A869BDBC5&w=${1}")
	# sed: remove <> tags
	word_translation=$(xpath "//acceptation" <<< "$xml" 2>/dev/null | sed 's/<\/*[[:alpha:]]*>//g')
	echo -e "$(tput setaf 3)【词译】$word_translation"

	# somehow last() doesn't work...
	# sed: remove <> rags
	# sed: remove lines after the first sentence
	# tr: remove newlines
	orig_example=$(xpath "//sent/orig[last()]" <<< "$xml" 2>/dev/null | 
		sed 's/<\/*[[:alpha:]]*>//g' | sed '3,$d' | tr -d "\n\r")
	echo -e "【例句】$orig_example"

	translated_example=$(xpath "//sent/trans[last()]" <<< "$xml" 2>/dev/null | 
		sed 's/<\/*[[:alpha:]]*>//g' | sed '3,$d' | tr -d "\n\r")
	echo -e "【句译】$translated_example $(tput sgr 0)"
}