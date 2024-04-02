# All the install steps

1. Set trackpad scrolling to natural. speed to fastest-2.
	- Set mouse tracking and scroll speed to the same level.
2. Turn on dark mode
3. Install `git`
4. Follow `README.md` to install nix configuration
	- Reboot
5. Setup 1password and ssh
	- change quick access keyboard shortcut to cmd-shft-l
	- mkdir ~/.ssh
	- enabled ssh agent for notion work laptop key
6. Sign into Apple ID
7. Setup finder
	- Remove all items from Dock
	- mkdir ~/Sandbox.
	- Drag ~/Sandbox and ~/. into sidebar
	- Remove Recents from sidebar
8. Install homebrew - https://brew.sh
9. Kandji apps:
	1pass - already installed
	Chrome -Already Installed
		Sign into personal first
		Create salmon colored profile for work
	Notion Calendar
		Sign in with work
	Notion Dev
	Testflight - App Store
	Okta - Already Installed
	Open vpn
		- search notion for setup
	Slack - Already Installed
	VsCode
		- Install Workspace default settings extension
	XCode - App Store
		- Download iOS extras
	Zoom - Already Installed
10. Install apps:
	Android Studio - https://developer.android.com/studio
		- Settings Repository sync. Overwrite local. Check 1pass for token
		- Turn on new UI
	BetterTouchTool? - if necessary https://folivora.ai/downloads
	Clipy - https://clipy-app.com/
	DaisyDisk - App Store
	DBeaver - brew install --cask dbeaver-community
	Dropbox?x - external download
	Handbrake - https://handbrake.fr/downloads.php
	iStat Menus - If necessary, app store
	Kap - https://getkap.co/
	KeyCastr? - brew install --cask keycastr
	Kitty - https://github.com/kovidgoyal/kitty/releases macos dmg
		- Pin to dock
	Mullvad VPN - https://mullvad.net/en/download/vpn/macos
	Pixelmator - App Store
	Safari Tech Preview - https://developer.apple.com/safari/resources/
	Sublime Text - https://www.sublimetext.com/download
	Sublime Merge - https://www.sublimemerge.com/
11. Setup work repo
	- Follow dev getting started
	- setup localhost before setting up mobile
		- Android studio, 16GB
		- brew install scrcpy
		- brew install bundletool
	- Reset this repo's upstream to use ssh link
		`git remote set-url origin git@github.com:dsyang/nixfiles.git`