#!/bin/bash


if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi


clear; echo -e "\e[1mWelcome to AutoInstallBuilder\e[0m"

uDir='/root/ubuntuauto'
uDis='/root/ubuntuauto/source-files'

uDat='/root/ubuntuauto/autoinstall-user-data'

link='https://old-releases.ubuntu.com/releases/jammy/ubuntu-22.04.2-live-server-amd64.iso'


ls "$uDir" > /dev/null 2>&1 ||
    { mkdir "$uDir" &&
          chmod 700 "$uDir" &&
              echo "$uDir                       - Created"; }

ls "$uDis" > /dev/null 2>&1 ||
    { mkdir "$uDis" &&
          chmod 700 "$uDis" &&
              echo "$uDis                       - Created"; }




# Define a function to display the menu
display_menu() {
    echo ""
    echo ""
    echo "Menu:"
    echo "1) download ubuntu-22.04.2-live-server-amd64"
    echo "2) set user-data"
    echo "3) cat user-data"
    echo "4) xorriso extract .iso"
    echo "5) update grub"
    echo "6) xorriso recreate .iso"
    echo "7) exit"
    echo "Enter your choice:"
}

# Main loop
while true; do
    # Display menu options
    display_menu

    # Read user input
    read choice

    # Handle user input
    case $choice in
        1)
            clear
            ls "$uDir"/*live-server-amd64.iso || wget "$link" -P "$uDir"
            echo -e "already downloaded \n"
            continue
            ;;
        2)
            checkRequirement_0=$(which whois)
            if [[ "$checkRequirement_0" == *"whois"* ]]; then
                echo 'whois is installed'
            else
                apt update; apt install -y whois
            fi

            clear

            echo "Enter hostname: "
            read hostname
            echo "Enter username: "
            read username
            echo "Enter password: "
            read password
            hashed_password=$(mkpasswd --method=SHA-512 "$password")


cat << EOF > $uDat
#cloud-config
autoinstall:
  version: 1
  identity:
    hostname: $hostname
    username: $username
    password: "$hashed_password"
  kernel:
    package: linux-generic
  ssh:
    install-server: true
    allow-pw: true
  locale: en_US.UTF-8
  keyboard:
    layout: us
  timezone: Europe/Belgrade
shutdown:
  mode: reboot
EOF

            chmod 700 $uDir/*
            continue
            ;;
        3)
            clear
            cat $uDat
            continue
            ;;
        4)
            clear
            checkRequirement_1=$(which xorriso)
            if [[ "$checkRequirement_1" == *"xorriso"* ]]; then
                echo 'xorriso is installed'
            else
                apt update; apt install -y xorriso
            fi

            rm -rf "$uDis"/*
            xorriso -osirrox on -indev "$uDir"/*live-server-amd64.iso --extract_boot_images "$uDis/bootpart" -extract / "$uDis"
            mkdir "$uDis"/nocloud && echo "$uDis/nocloud           - Created"
            cp $uDat "$uDis"/nocloud/user-data && echo "$uDis/nocloud/user-data - Copied"
            touch "$uDis"/nocloud/meta-data
            continue
            ;;
        5)
            chmod 700 "$uDis"/boot/grub/grub.cfg
cat << 'EOF' >"$uDis"/boot/grub/grub.cfg
set timeout=3

loadfont unicode

set menu_color_normal=white/black
set menu_color_highlight=black/light-gray

menuentry "AutoInstall" {
    set gfxpayload=keep
    linux   /casper/vmlinuz autoinstall ds=nocloud\;s=/cdrom/nocloud/ ---
    initrd  /casper/initrd.gz
}
menuentry 'Test memory' {
    linux16 /boot/memtest86+.bin
}
EOF
            clear
            echo "grub menu updated!"
            echo "$uDis/boot/grub/grub.cfg"
            continue
            ;;
        6)
            clear
            xorriso -as mkisofs \
                -r -V "ubuntu-autoinstall" \
                -J -boot-load-size 4 -boot-info-table \
                -input-charset utf-8 \
                -eltorito-alt-boot \
                -b /bootpart/eltorito_img1_bios.img \
                --no-emul-boot \
                -o "$uDir/installer.iso" \
                "$uDis"
                sleep 1 && clear
                ls "$uDir"/installer.iso && chmod 777 "$uDir"/installer.iso
            break
            ;;
        7)
            echo "Exiting..." && sleep 1
            clear
            break  # Exit the loop and end the script
            ;;
        *)
            clear
            echo "Invalid choice. Please enter a number between 1 and 4."
            ;;
    esac
done
