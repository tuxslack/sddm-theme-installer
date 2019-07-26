## Usage
1. Edit `$NAME`, `$DIR`, and `$CFG` where needed
2. Run `./install.sh` from the root your your theme directory

The install script moves the theme folder by default to `/usr/share/sddm/themes/$NAME` and modifies `/etc/sddm.conf` to set this theme as the Current theme. If `/etc/sddm.conf` file does not exists, the user will be prompted to automatically create one based on currently active settings. The user will be prompted to disable SDDM's virtual keyboard if it is enabled, because it is not well supported by the theme, and it is for some reason enabled in SDDM by default. After this, the script will suggest to test the theme. You can also manually move the files to the correct location. If you use KDE Plasma, you can set the new theme in System Settings → Startup and Shutdown → Login Screen (SDDM).
