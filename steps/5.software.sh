#!/usr/bin/env bash

###############################################################################
# PREVENT PEOPLE FROM SHOOTING THEMSELVES IN THE FOOT                         #
###############################################################################

starting_script=`basename "$0"`
if [ "$starting_script" != "freshinstall.sh" ]; then
	echo -e "\n\033[31m\aUhoh!\033[0m This script is part of freshinstall and should not be run by itself."
	echo -e "Please launch freshinstall itself using \033[1m./freshinstall.sh\033[0m"
	echo -e "\n\033[93mMy journey stops here (for now) … bye! 👋\033[0m\n"
	exit 1
fi;


###############################################################################
# Prerequisites                                                               #
###############################################################################

mkdir -p /usr/local/bin
sudo chown -R $(whoami) /usr/local/bin

# Important Apps upfront
brew install --cask 1password

###############################################################################
# Code Editors                                                                #
###############################################################################

brew install --cask visual-studio-code
# @note: Settings + Plugins via https://code.visualstudio.com/docs/editor/settings-sync

# Create a `code` symlink to open files via the `code` CLI command
ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /opt/homebrew/bin/code

# Open files by default with VSCode
#
# Note that duti is preferred over the command below, as the latter requires a reboot
# 	defaults write com.apple.LaunchServices LSHandlers -array-add '{"LSHandlerContentType" = "public.plain-text"; "LSHandlerPreferredVersions" = { "LSHandlerRoleAll" = "-"; }; LSHandlerRoleAll = "com.sublimetext.3";}'
#
# Some pointers:
# - To get identifier of an app:
#     $ /usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' /Applications/Sublime\ Text.app/Contents/Info.plist
#     $ osascript -e 'id of app "Visual Studio Code.app"'
# - To get UTI of a file: mdls -name kMDItemContentTypeTree /path/to/file.ext
#
brew install duti
duti -s com.microsoft.VSCode public.data all # for files like ~/.bash_profile
duti -s com.microsoft.VSCode public.plain-text all
duti -s com.microsoft.VSCode public.script all
duti -s com.microsoft.VSCode net.daringfireball.markdown all

###############################################################################
# NPM                                                                         #
###############################################################################

# @NOTE: NVM already installed via ZSH
nvm install node
nvm use node

NPM_USER=""
echo -e "\nWhat's your NPMJS username?"
echo -ne "> \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && NPM_USER=$REPLY  # @TODO: Rework to a Y/n prompt

if [ "$NPM_USER" != "" ]; then
	npm adduser
fi;

###############################################################################
# Mac App Store                                                               #
###############################################################################

brew install mas
# Apple ID
if [ -n "$(defaults read NSGlobalDomain AppleID 2>&1 | grep -E "( does not exist)$")" ]; then
	AppleID=""
else
	AppleID="$(defaults read NSGlobalDomain AppleID)"
fi;
echo -e "\nWhat's your Apple ID? (default: $AppleID)"
echo -ne "> \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && AppleID=$REPLY

if [ "$AppleID" != "" ]; then

	# Sign in
	# No longer suppported: https://github.com/mas-cli/mas/issues/164
	# But as we have already downloaded Xcode, we should already be logged into the store …
	# mas signin $AppleID

	# Xcode
	# Already installed!
	# mas install 497799835 # Xcode

	# iWork
	mas install 409203825 # Numbers
	mas install 409201541 # Pages
	mas install 409183694 # Keynote

	# Others
	mas install 1176895641 # Spark Email Client
	mas install 1055511498 # Day One
	mas install 405772121 # Little Ipsum
	mas install 1043270657 # GIF Keyboard
	mas install 494803304 # Wifi Explorer
	mas install 803453959 # Slack
	mas install 1006739057 # NepTunes (Last.fm Scrobbling)
	mas install 411643860 # DaisyDisk

fi;

###############################################################################
# BROWSERS                                                                    #
###############################################################################

brew install --cask google-chrome
brew install --cask firefox
brew install --cask microsoft-edge

brew tap homebrew/cask-versions
brew install --cask google-chrome-canary
brew install --cask firefox-developer-edition
brew install --cask firefox-nightly
brew install --cask safari-technology-preview

###############################################################################
# IMAGE & VIDEO PROCESSING                                                    #
###############################################################################

brew install imagemagick

brew install libvpx
brew install ffmpeg

###############################################################################
# OTHER BREW/CASK THINGS                                                      #
###############################################################################

brew install --cask vlc
duti -s org.videolan.vlc public.movie all
duti -s org.videolan.vlc public.avi all
duti -s org.videolan.vlc public.mpeg-4 all

brew install --cask microsoft-teams
brew install --cask zoom

brew install --cask dropbox
brew install --cask setapp

brew install --cask abstract
brew install --cask sketch

brew install --cask iterm2
brew install --cask sourcetree
brew install --cask fantastical
brew install --cask textmate

brew install --cask spotify
brew install --cask pocket-casts

brew install --cask imagealpha
brew install --cask imageoptim

brew install --cask postman # @note: Workspace + Environments auto synced via account login

brew install --cask little-snitch
brew install --cask grammarly

###############################################################################
# Virtual Machines and stuff                                                  #
###############################################################################

brew install --cask docker

###############################################################################
# ALL DONE NOW!                                                               #
###############################################################################

echo -e "\n\033[93mSo, that should've installed all software for you …\033[0m"
echo -e "\n\033[93mYou'll have to install the following manually though:\033[0m"

echo "- Additional Tools for Xcode"
echo ""
echo "    Download from https://developer.apple.com/download/more/"
echo "    Mount the .dmg + install it from the Graphics subfolder"
echo ""
