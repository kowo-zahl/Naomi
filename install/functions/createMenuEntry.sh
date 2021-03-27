#!/bin/bash

createMenuEntry() {
    echo '[Desktop Entry]' > ~/Desktop/Naomi.desktop
    echo 'Name=Naomi' >> ~/Desktop/Naomi.desktop
    echo 'Comment=Your privacy respecting digital assistant' >> ~/Desktop/Naomi.desktop
    echo 'Icon=/home/pi/Naomi/Naomi.png' >> ~/Desktop/Naomi.desktop
    echo 'Exec=Naomi' >> ~/Desktop/Naomi.desktop
    echo 'Type=Application' >> ~/Desktop/Naomi.desktop
    echo 'Encoding=UTF-8' >> ~/Desktop/Naomi.desktop
    echo 'Terminal=True' >> ~/Desktop/Naomi.desktop
    echo 'Categories=None;' >> ~/Desktop/Naomi.desktop
}
