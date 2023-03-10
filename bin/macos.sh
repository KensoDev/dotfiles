#!/bin/sh

# This script is intended to work on macOS Monterey 
# running on the Apple M1 chip.
#
# These are gathered from many different sources.
#
# Thanks:
#
#   * https://macos-defaults.com
#   * https://github.com/paulmillr/dotfiles
#   * https://github.com/mathiasbynens/dotfiles
#   * https://github.com/stianeikeland/dotfiles/edit/master/bin/sanemacdefaults.sh
#   * https://www.taniarascia.com/setting-up-a-brand-new-mac-for-development/

## Software Update

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Automatically download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

## NSGlobalDomain

# Show all filename extensions.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable subpixel font rendering on non-Apple LCDs.
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Always show scrollbars.
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Use “natural” (Lion-style) scrolling.
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Disable press-and-hold for keys in favor of key repeat.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a fast KeyRepeat rate. We prefer 1 (15ms). The default minimum is 2 (30ms). May require reboot.
defaults write NSGlobalDomain KeyRepeat -int 1 

# Set a fast initial key repeat. We prefer 4 (60ms). The default minimum is 15 (225ms). May require reboot.
defaults write NSGlobalDomain InitialKeyRepeat -int 15

## NSGlobalDomain NS*

# Save to disk (not to iCloud) by default.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable typing automatic capitalization.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable typingautomatic period substition a.k.a. "smart stops".
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -int 0

# Disable typing automatic dash substitution e.g. "smart dashes".
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable typing automatic quote substitution a.k.a. "smart quotes".
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable typing automatic spelling correction a.k.a. "auto-correct".
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Expand save panel by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Speed up window resize time.
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

## Finder

# Show all files.
defaults write com.apple.finder AppleShowAllFiles YES

# Show all extensions.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Empty the trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Disable the warning when changing a file extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Always open everything in Finder's list view
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Allow selection of text in quicklook windows.
defaults write com.apple.finder QLEnableTextSelection -bool true

# Enable quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Show status bar.
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar.
defaults write com.apple.finder ShowPathbar -bool true

## Dock

# Make Dock icons of hidden applications translucent.
defaults write com.apple.dock showhidden -bool true

# Enable iTunes track notifications in the Dock.
# defaults write com.apple.dock itunes-notifications -bool true

# Show indicator lights for open applications in the Dock.
defaults write com.apple.dock show-process-indicators -bool true

# Remove the auto-hiding Dock delay.
defaults write com.apple.Dock autohide-delay -float 0

# Disable expose animation.
defaults write com.apple.dock expose-animation-duration -float 0


## Network Browser

# Use AirDrop over every interface.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

## Desktop Services

# Avoid creating .DS_Store files on network volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true


## Bluetooth

# Set Bluetooth headset higher bitrate.
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40


## Press And Hold

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false


## Trackpad

# Enable tap to click (Trackpad), also for login menu.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 0
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 0
sudo defaults write com.apple.AppleMultitouchTrackpad Clicking 5


## Flags

# Show the ~/Library folder.
chflags nohidden ~/Library


## Login window

# Show host info e.g. IP address, hostname, OS version, etc. when you click the clock
# sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName


## Finally

# Kill affected applications.
for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
